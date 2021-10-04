# frozen_string_literal: true

class Summary < ApplicationRecord
  belongs_to :tran, class_name: 'Transaction', foreign_key: :transaction_id

  validate :data_as_hash

  before_save :set_transaction_name

  class << self
    def init(tran)
      SummaryData.new(last_data)
      sd.init(tran.target_account.code)

      create(transaction_id: tran.id, data: sd.to_json)
    end

    def value_for(code)
      last_data[code.downcase]
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
        output[key.upcase] = last_data_row(key, value, prev)
      end
      output
    end

    private

    def last_data_row(code, value, prev)
      previous_value = prev[code].to_f
      increased_by = value - previous_value

      {
        value: value,
        previous: previous_value,
        current: value,
        updated: (increased_by != 0),
        increased_by: increased_by,
        is_account: Entity.find_by(code: code.upcase).account?
      }
    end
  end

  def values
    JSON.parse(data).transform_values(&:to_d)
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
