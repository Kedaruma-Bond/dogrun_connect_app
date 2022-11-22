class TogoInuShitsukeHiroba::StaticPagesController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, only: %i[top]
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[top]
  before_action :get_dogrun_entry_data, only: %i[top]
  around_action :skip_bullet, if: -> { defined?(Bullet) }

  def top
    @dogrun_place = DogrunPlace.find(2)
    return unless logged_in?
    @entry = Entry.new
    @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?
    @publishing_post = Post.where(publish_status: 'is_publishing').where(dogrun_place: @dogrun_place)
    
    return if @dogrun_entry_data.blank?
    dogs = @dogrun_entry_data.map do |entry_data|
      Dog.find(entry_data.dog_id)
    end

    @dogs_public_view = dogs.select do |dog|
      dog.public == 'public_view'
    end

    @dogs_non_public = dogs.select do |dog|
      dog.public == 'non_public'
    end
  end

  private
  
    def get_dogrun_entry_data
      @dogrun_entry_data = []
      @dogrun_entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place_id: 2 })
      @num_of_playing_dogs = @dogrun_entry_data.size || 0
    end
end
