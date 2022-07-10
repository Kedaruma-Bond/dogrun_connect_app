class TogoInuShitsukeHiroba::EntriesController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :set_dog, only: %i[create update]
  before_action :set_registration_number, only: %i[create update]

  def create
    @entry = Entry.new(entry_params)
    @entry.entry_at = Time.zone.now
    return unless @entry.save!

    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.entry_success')
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.exit_at = Time.zone.now
    return unless @entry.update(entry_params)

    redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.exit_success')
  end

  private

  def set_dog
    @dog = Dog.where(user_id: current_user.id)
  end

  def set_registration_number
    @registration_number = RegistrationNumber.where(dog_id: @dog.id).merge(RegistrationNumber.where(dogrun: 'togo_inu_shitsuke_hiroba'))
  end

  def entry_params
    params.require(:entry).permit(
      :dog_id, :registration_number_id,
      :entry_at, :exit_at
    ).merge(
      dog_id: @dog.id,
      registration_number_id: @registration_number.id
    )
  end
end
