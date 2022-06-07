class ContactsController < ApplicationController
  before_action :contact_params, only: :confirm

  def new
    session.delete(:contact)
    @contact = Contact.new
  end

  def back
    @contact = Contact.new(session[:contact])
    session.delete(:contact)
    render :new, status: :unprocessable_entity
  end

  def confirm
    @contact = Contact.new(contact_params)
    session[:contact] = @contact
    return unless @contact.invalid?

    render :new
  end

  def create
    @contact = Contact.new(session[:contact])
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to '/', notice: t('.notice')
      session.delete(:cotact)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
