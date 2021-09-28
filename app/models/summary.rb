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

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def transfer(tran)
      hash = last_data
      hash[tran.source_account.code] -= tran.amount_cents
      hash[tran.target_account.code] += tran.amount_cents

      create(transaction_id: tran.id, data: hash.to_json)
    end

    def last_data
      JSON.parse(Summary.last&.data || "{}")
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
