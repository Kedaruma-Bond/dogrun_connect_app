class ContactsController < ApplicationController
  before_action :contact_params, only: :confirm

  def index
    @contacs = Contacts.all
  end
  
  def new
    session.delete(:contact)
    @contact = Contact.new
  end

  def confirm
    # editとnewに対応させるためfind_or_initializeする
    @contact = Contact.find_or_initialize_by(id: params[:id])
    session[:contact] = contact_params
    @contact.assign_attributes(session[:contact])
  end

  def back
    @contact = Contact.new(session[:contact])
    session.delete(:contact)
    render :new, status: :unprocessable_entity
  end

  def create
    @contact = Contact.new(session[:contact])
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      session.delete(:cotact)
      redirect_to '/', notice: t('.notice')
    else
      render :new, status: :unprocessable_entit, error: t('.send_mail_fail')
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
