FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "bond-#{n}" }
    sequence(:email) { |n| "bond_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :general_user do
      role { 'general' }
    end

    trait :admin_user do
      role { 'admin' }
    end

    trait :grand_admin do
      role { 'admin' }
      name { 'grand_admin' }
    end

    trait :guest_user do
      role { 'guest' }
    end

    trait :account_BAN do
      deactivation { 'account_frozen' }
    end
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
