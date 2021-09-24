class Summary < ApplicationRecord
  belongs_to :tran, class_name: "Transaction", foreign_key: :transaction_id

  validate :data_as_hash

  before_save :set_transaction_name

  class << self
    def add_key(tran)
      create(
        transaction_id: tran.id,
        data: add_key_updated_data(tran)
      )
    end

    private

    def add_key_updated_data(tran)
      hash = JSON.parse(Summary.last&.data || "{}")
      hash[tran.target_account.code] = 0
      hash.to_json
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