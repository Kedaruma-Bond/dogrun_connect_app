class TogoInuShitsukeHiroba::DogsController < ApplicationController
  layout 'togo_inu_shitsuke_hiroba'
  before_action :dog_params, only: :confirm
  begore_action :set_dog, only: %i[edit update show destroy]

  def index; end

  def new
    session.delete(:dog_form)
    @dog = DogRe.new
  end

  def comfirm
    @dog = Dog.new(dog_params)
    if @dog.valid?
      session[:dog_form] = dog_params
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
      session.delete(:dog_form)
      redirect_to togo_inu_shitsuke_hiroba_top_path, success: t('.dog_registrated')
      return
    end
    render :new, status: :unprocessable_entity, error: t('.something_wrong')
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def dog_params
    params.require(:dog).permit(
      :name, :castration, :public, :breed,
      :birthday, :weight, :owner_comment
    )
  end

  def set_dog
    @dog = Dog.find(params[:id])
  end
end
