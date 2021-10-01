class Summary < ApplicationRecord
  belongs_to :tran, class_name: "Transaction", foreign_key: :transaction_id

  validate :data_as_hash

  before_save :set_transaction_name

  class << self
    def add_key(tran)
      hash = last_data
      hash[tran.target_account.code] = 0

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def increment_both(tran)
      hash = last_data
      hash[tran.source_account.code] += tran.amount_cents
      hash[tran.target_account.code] += tran.amount_cents

      code = tran.source_account.code
      while true
        parent = Entity.find_by(code: code).parent
        break if parent.nil?
        hash[parent.code] += tran.amount_cents
        code = parent.code
      end

      code = tran.target_account.code
      while true
        parent = Entity.find_by(code: code).parent
        break if parent.nil?
        hash[parent.code] += tran.amount_cents
        code = parent.code
      end

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def transfer(tran)
      hash = last_data
      hash[tran.source_account.code] -= tran.amount_cents
      hash[tran.target_account.code] += tran.amount_cents

      code = tran.source_account.code
      while true
        parent = Entity.find_by(code: code).parent
        break if parent.nil?
        hash[parent.code] -= tran.amount_cents
        code = parent.code
      end

      code = tran.target_account.code
      while true
        parent = Entity.find_by(code: code).parent
        break if parent.nil?
        hash[parent.code] += tran.amount_cents
        code = parent.code
      end

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def last_data
      JSON.parse(Summary.last&.data || "{}")
    end

    def last_data_with_updated
      prev    = JSON.parse(Summary.second_to_last&.data || "{}")
      current = JSON.parse(Summary.last&.data || "{}")
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
  end

  def data_hash
    JSON.parse(data)
  end

  private

  def set_transaction_name
    self.transaction_name = tran.transaction_type.name
  end

  def data_as_hash
    JSON.parse(self.data)
  rescue JSON::ParserError
    errors.add(:data, "cannot accept invalid JSON string")
  end
end
