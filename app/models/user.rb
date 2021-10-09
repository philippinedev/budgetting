# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validate :username_validator

  def name
    username.capitalize.squish.split.map(&:capitalize).join(" ")
  end

  private

  def username_validator
    unless username.length >= 3 && username.length <= 20
      errors.add(:username, 'must be between 3 and 28 characters long')
    end

    unless username =~ /\A[ -_a-zA-Z0-9]*\z/
      errors.add(:username, "must only contain A-Z, 0-9, hyphens, or underscores")
    end

    if username =~ /[-_]{2}/
      errors.add(:username, "cannot contain two consecutive hyphens and underscores")
    end

    if username =~ /\A[-_]/ || username =~ /[-_]\z/
      errors.add(:username, "shouldn't start or end with a hyphen or underscore")
    end

    if username =~ /\A[0-9]/
      errors.add(:username, "shouldn't start with a number")
    end

    if username =~ /\./
      errors.add(:username, "shouldn't contain periods")
    end
  end
end
