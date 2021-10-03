# frozen_string_literal: true

class AddAdminUser < ActiveRecord::Migration[6.1]
  def up
    user = User.new
    user.admin = true
    user.email = 'admin@test.com'
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
