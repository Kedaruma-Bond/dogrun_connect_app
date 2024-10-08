class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :dogs, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :encount_dogs, dependent: :destroy
  has_many :encounts, dependent: :destroy
  belongs_to :dogrun_place, optional: true
  has_one :sns_account, dependent: :destroy
  has_one :user_detail, dependent: :destroy

  attr_accessor :agreement

  # validations
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 50 }, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true, email_format: { message: I18n.t('defaults.email_message') }, if: -> { new_record? || changes[:crypted_password] }
  validates :agreement, acceptance: true, on: :create
  validates :agreement, acceptance: true, on: :update, allow_blank: true

  #enum
  enum role: { general: 0, admin: 1, guest: 2, grand_admin: 3 }
  enum deactivation: { account_frozen: true, account_activated: false }

  # sorceryの垢BAN method
  def active_for_authentication?
    !account_frozen?
  end

  # ransacl autorization
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deactivation", "dogrun_place_id", "email", "name", "reset_password_token_expires_at", "role", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["dogrun_place", "dogs", "encount_dogs", "encounts", "posts", "sns_account", "user_detail"]
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  crypted_password                    :string
#  deactivation                        :boolean          default("account_activated"), not null
#  email                               :string           not null
#  failed_logins_count                 :integer          default(0)
#  lock_expires_at                     :datetime
#  name                                :string           not null
#  remember_me_token                   :string
#  remember_me_token_expires_at        :datetime
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  role                                :integer          default("general"), not null
#  salt                                :string
#  unlock_token                        :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  dogrun_place_id                     :bigint
#
# Indexes
#
#  index_users_on_dogrun_place_id       (dogrun_place_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#  index_users_on_unlock_token          (unlock_token)
#
# Foreign Keys
#
#  fk_rails_...  (dogrun_place_id => dogrun_places.id)
#
