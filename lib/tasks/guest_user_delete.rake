namespace :guest_user_delete do
  desc "roleがguestのUserをまとめて削除する"
  task delete_guest_user: :environment do
    User.where(role: 'guest').delete_all
  end
end
