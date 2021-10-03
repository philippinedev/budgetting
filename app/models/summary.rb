# frozen_string_literal: true

class Summary < ApplicationRecord
  belongs_to :tran, class_name: 'Transaction', foreign_key: :transaction_id

  validate :data_as_hash

  before_save :set_transaction_name

  class << self
    def add_key(tran)
      hash = last_data
      hash[tran.target_account.code] = 0

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def increase_both(tran)
      hash = last_data
      hash[tran.source_account.code] += tran.amount_cents
      hash[tran.target_account.code] += tran.amount_cents
      hash = update_parent(hash, tran.source_account.code, tran.amount_cents, :+)
      hash = update_parent(hash, tran.target_account.code, tran.amount_cents, :+)

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def decrease_both(tran)
      hash = last_data
      hash[tran.source_account.code] -= tran.amount_cents
      hash[tran.target_account.code] -= tran.amount_cents
      hash = update_parent(hash, tran.source_account.code, tran.amount_cents, :-)
      hash = update_parent(hash, tran.target_account.code, tran.amount_cents, :-)

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def transfer(tran)
      hash = last_data

      hash[tran.source_account.code] -= tran.amount_cents
      hash[tran.target_account.code] += tran.amount_cents

      hash = update_parent(hash, tran.source_account.code, tran.amount_cents, :-)
      hash = update_parent(hash, tran.target_account.code, tran.amount_cents, :+)

      transaction_fee_cents = tran.transaction_type.expense_category&.transaction_fee_cents

      if transaction_fee_cents.present?
        hash[tran.source_account.code] -= transaction_fee_cents
        hash = update_parent(
          hash,
          tran.source_account.code,
          transaction_fee_cents,
          :-
        )

        hash[tran.transaction_type.expense_category.code] += transaction_fee_cents
        hash = update_parent(
          hash,
          tran.transaction_type.expense_category.code,
          transaction_fee_cents,
          :+
        )
      end

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def last_data
      JSON.parse(Summary.last&.data || '{}').transform_values(&:to_d)
    end

    def last_data_with_updated
      prev    = JSON.parse(Summary.second_to_last&.data || '{}').transform_values(&:to_d)
      current = JSON.parse(Summary.last&.data || '{}').transform_values(&:to_d)
      output  = {}

      current.each do |key, value|
        increased_by = value - prev[key].to_f

        output[key] = {
          value: value,
          previous: prev[key],
          current: value,
          updated: (increased_by != 0),
          increased_by: increased_by,
          is_account: Entity.find_by(code: key).account?
        }
      end

      output
    end

    private

    def update_parent(hash, code, amount_cents, operation)
      parent = Entity.find_by(code: code).parent

      while parent.present?
        hash[parent.code] = hash[parent.code].send(operation, amount_cents)
        parent = Entity.find_by(code: parent.code).parent
      end

      hash
    end
  end

  def data_hash
    JSON.parse(data)
  end

  private

  def set_transaction_name
    self.transaction_name = tran.transaction_type.name
  end

  def data_as_hash
    JSON.parse(data)
  rescue JSON::ParserError
    errors.add(:data, 'cannot accept invalid JSON string')
  end
end
