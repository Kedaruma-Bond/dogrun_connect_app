class ContactsController < ApplicationController
  skip_before_action :require_login
  before_action :contact_params, only: :confirm

  def new
    session.delete(:contact)
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.valid?
      session[:contact] = contact_params
    else
      render :new
    end
  end

  def create
    @contact = Contact.new(session[:contact].to_hash)
    if params[:back]
      render :new,  :unprocessable_entity
      return
    end

    return unless @contact.save!

    ContactMailer.send_mail(@contact).deliver_now
    session.delete(:contact)
    redirect_to '/', success: t('.success')
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
