class TogoInuShitsukeHiroba::DogsController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :dog_params, only: :confirm

  def new
    session.delete(:dog_form)
    @dog = Dog.new
  end

  def comfirm
    @dog = Dog.new(dog_params)
    if @dog.valid?
      session[:dog_from] = dog_params
    else
      render :new
    end
  end

  def create
    @dog = Dog.new(session[:dog].to_hash)
    if params[:back]
      render :new, status: :unprocessable_entity
      return
    end

    if @dog.save
      DogMailer.dog_registrated_success(@dog)
      session.delete(:dog)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.dog_registrated')
      return
    end
    render :new, status: :unprocessable_entity, error: t('.something_wrong')
  end

  private

  def dog_params
    params.require(:dog).permit(
      :name, :castration, :public, :breed,
      :birthday, :weight, :owner_comment
    )
  end
end
