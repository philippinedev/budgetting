# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validate  :first_name_validator
  validate  :last_name_validator

  def name
    ("#{first_name} #{last_name}").split.map(&:capitalize).join(" ")
  end

  private

  def first_name_validator
    unless first_name.length >= 3 && first_name.length <= 20
      errors.add(:first_name, valid_length)
    end

    unless first_name =~ /\A[a-zA-Z]*\z/
      errors.add(:first_name, valid_characters)
    end
  end

  def last_name_validator
    unless last_name.length <= 20
      errors.add(:last_name, valid_length)
    end

    unless last_name =~ /\A[a-zA-Z]*\z/
      errors.add(:last_name, valid_characters)
    end
  end

  def valid_length
    "must be between 3 and 20 characters long"
  end

  def valid_characters
    "must only contain alphabetic characters"
  end
end
