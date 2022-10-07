class TogoInuShitsukeHiroba::FriendDogGeneratorJob < ApplicationJob
  queue_as :default

  def perform
    if Rails.cache.exist?('counter')
      counter = Rails.cache.read('counter')
      counter += 1
      p "*" * 10
      p counter
      p "*" * 10
      Rails.cache.write('counter', counter)
      Rails.cache.delete('counter') if counter == 10
      counter = 0
    else
      Rails.cache.write('counter', 0)
    end
  end
end
