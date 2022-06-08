class ContactsController < ApplicationController
  before_action :contact_params, only: :confirm

  def new
    session.delete(:contact)
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(@contact_params)
    session[:contact] = @contact.hash
    return unless @contact.invalid?

    render :new
  end

  def back
    @contact = Contact.new(session[:contact])
    session.delete(:contact)
    render :new, status: :unprocessable_entity
  end

  def create
    # @contact = Contact.new(session[:contact])
    if Contact.create(session[:contact])
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to '/', notice: t('.notice')
      session.delete(:cotact)
    else
      render :new, status: :unprocessable_entit, error: t('.send_mail_fail')
    end
  end

  private

  def contact_params
    @contact_params = params.require(:contact).permit(:name, :email, :message)
  end
end
