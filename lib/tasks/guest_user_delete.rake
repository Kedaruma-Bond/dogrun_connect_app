namespace :guest_user_delete do
  desc "毎日AM03:00にroleがguestのUserをまとめて削除します"
  task delete_guest_user: :environment do
    User.where(role: 'guest').delete_all
  end
end
