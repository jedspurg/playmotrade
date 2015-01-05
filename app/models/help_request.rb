class HelpRequest < ActiveRecord::Base
  belongs_to :user

  validates :name, :email, :comment, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end
