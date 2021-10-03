# frozen_string_literal: true

json.array! @account_types, partial: 'account_types/account_type', as: :account_type
