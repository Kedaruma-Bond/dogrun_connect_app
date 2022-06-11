class ContactsController < ApplicationController
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
      render :new, status: :unprocessable_entity
      return
    end

    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      session.delete(:contact)
      redirect_to '/', success: t('.success')
      return
    end
    render :new, status: :unprocessable_entity, error: t('.send_mail_fail')
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
