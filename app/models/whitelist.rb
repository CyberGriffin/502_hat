class Whitelist < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def expired?
    expires_at.present? && expires_at < Date.today
  end
end
