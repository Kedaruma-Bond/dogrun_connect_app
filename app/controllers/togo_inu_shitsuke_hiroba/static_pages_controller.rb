class TogoInuShitsukeHiroba::StaticPagesController < TogoInuShitsukeHiroba::DogrunPlaceController
  skip_before_action :require_login, except: %i[detail]
  before_action :set_dogs, :set_registration_numbers_in_togo_inu_shitsuke_hiroba, :during_entries, :get_during_entry_user_dogs, only: %i[top]
  before_action :get_dogrun_entry_data, only: %i[top detail]
  around_action :skip_bullet, if: -> { defined?(Bullet) }

  def top
    @entry = Entry.new
    return if !logged_in?
    @user_dog_entry = Entry.where(exit_at: nil).user_id(current_user.id)
    @publishing_post = Post.where(publish_status: 'is_publishing').where(dogrun_place: 2)
  end

  def detail
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

    def get_during_entry_user_dogs
      return if not_entry?

      entries = []
      @during_entry_user_dogs = []
      num = @during_entries.size || 0
      x = 0
      num.times do
        entries += Entry.where('id = ?', @during_entries[x])
        @during_entry_user_dogs += Dog.where('id = ?', entries[x].dog_id)
        x += 1
      end
    end

    def skip_bullet
      previous_value = Bullet.enable?
      Bullet.enable = false
      yield
    ensure
      Bullet.enable = previous_value
    end
end
