FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "bond-#{n}" }
    sequence(:email) { |n| "bond_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  crypted_password                    :string
#  deactivation                        :boolean          default(FALSE), not null
#  email                               :string           not null
#  enable_notification                 :boolean          default(FALSE), not null
#  failed_logins_count                 :integer          default(0)
#  lock_expires_at                     :datetime
#  name                                :string           not null
#  remember_me_token                   :string
#  remember_me_token_expires_at        :datetime
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  salt                                :string
#  unlock_token                        :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#  index_users_on_unlock_token          (unlock_token)
#
