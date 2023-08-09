class Reon::StaticPagesController < Reon::DogrunPlaceController
  skip_before_action :require_login, :is_account_deactivated?, only: %i[top]
  before_action :set_new_post, only: %i[top]
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[top_contents]
  before_action :get_dogrun_entry_data, only: %i[top_contents]

  def top
    return unless logged_in?
    
    unless current_user.active_for_authentication?
      logout
      redirect_to root_path, error: t('defaults.your_account_is_deactivating')
      return
    end
    
    @publishing_post = Post.where(publish_status: 'is_publishing').where(dogrun_place: @dogrun_place)
  end

  def top_contents
    @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?(current_user, @dogrun_place)
    
    if !@dogrun_entry_data.blank?
      dogs = @dogrun_entry_data.map do |entry_data|
        Dog.find(entry_data.dog_id)
      end
  
      @dogs_public_view = dogs.select do |dog|
        dog.public == 'public_view'
      end
  
      @dogs_non_public = dogs.select do |dog|
        dog.public == 'non_public'
      end
    else
      @dogs_public_view = []
      @dogs_non_public = [] 
    end

    if !@dogrun_pre_entry_data.blank?
      pre_entry_dogs = @dogrun_pre_entry_data.map do |pre_entry_data|
        Dog.find(pre_entry_data.dog_id)
      end

      @pre_entry_dogs_public_view = pre_entry_dogs.select do |dog|
        dog.public == 'public_view'
      end
    else
      @pre_entry_dogs_public_view  = []
    end
  end

  private
  
    def get_dogrun_entry_data
      @dogrun_entry_data = []
      @dogrun_entry_data = Entry.where.not(entry_at: nil).where(exit_at: nil).joins(:registration_number).where(registration_numbers: { dogrun_place: @dogrun_place }).order(created_at: :asc)
      @dogrun_pre_entry_data = []
      @dogrun_pre_entry_data = PreEntry.joins(:registration_number).where(registration_numbers: { dogrun_place: @dogrun_place }).order(created_at: :asc)
      @num_of_playing_dogs = @dogrun_entry_data.size || 0
    end
end
