# frozen_string_literal: true

class Summary < ApplicationRecord
  belongs_to :tran, class_name: 'Transaction', foreign_key: :transaction_id

  validate :data_as_hash

  before_save :set_transaction_name

  class << self
    def init(tran)
      hash = last_data
      hash[tran.target_account.code] = 0

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def increase_both(tran)
      create(
        transaction_id: tran.id,
        data: update_both(tran, :+).to_json
      )
    end

    def decrease_both(tran)
      create(
        transaction_id: tran.id,
        data: update_both(tran, :-).to_json
      )
    end

    def transfer(tran)
      create(
        transaction_id: tran.id,
        data: transfer_update_by_transaction(tran).to_json
      )
    end

    def last_data
      JSON.parse(Summary.last&.data || '{}').transform_values(&:to_d)
    end

    def previous_data
      JSON.parse(Summary.second_to_last&.data || '{}').transform_values(&:to_d)
    end

    def last_data_with_updated
      prev = previous_data
      output = {}
      last_data.each do |key, value|
        output[key] = last_data_row(key, value, prev)
      end
      output
    end

    private

    def update_both(tran, operation)
      hash = last_data
      hash[tran.source_account.code] = hash[tran.source_account.code].send(operation, tran.amount_cents)
      hash[tran.target_account.code] = hash[tran.target_account.code].send(operation, tran.amount_cents)
      hash = update_parent(hash, tran.source_account.code, tran.amount_cents, operation)
      update_parent(hash, tran.target_account.code, tran.amount_cents, operation)
    end

    def transfer_update_by_transaction(tran)
      hash = last_data
      hash = update_hash(hash, tran.source_account.code, tran.amount_cents, :-)
      hash = update_hash(hash, tran.target_account.code, tran.amount_cents, :+)
      transfer_update_fee(hash, tran)
    end

    def transfer_update_fee(hash, tran)
      fee_cents = tran.transaction_type.expense_category&.transaction_fee_cents
      if fee_cents.present?
        hash = update_hash(hash, tran.source_account.code, fee_cents, :-)
        hash = update_hash(hash, tran.transaction_type.expense_category.code, fee_cents, :+)
      end
      hash
    end

    def update_hash(hash, code, amount_cents, operation)
      hash[code] = hash[code].send(operation, amount_cents)
      update_parent(hash, code, amount_cents, operation)
    end

    def last_data_row(code, value, prev)
      increased_by = value - prev[code].to_f

      {
        value: value,
        previous: prev[code],
        current: value,
        updated: (increased_by != 0),
        increased_by: increased_by,
        is_account: Entity.find_by(code: code).account?
      }
    end

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
