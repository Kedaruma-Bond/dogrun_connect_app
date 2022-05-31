module TogoInuShitsukeHiroba
  class ContactsController < ApplicationController
    def new
      @contact = Contact.new
    end

    def confirm
      @contact = Contact.new(contact_params)
      return unless @contact.invalid?

      render :new
    end

    def back
      @contact = Contact.new(contact_params)
      render action: 'new', status: :unprocessable_entity
    end

    def create
      @contact = Contact.new(contact_params)
      if @contact.save
        ContactMailer.send_mail(@contact).deliver_now
        redirect_to '/togo_inu_shitsuke_hiroba/top', notice: t('.notice')
      else
        render action: 'new', status: :unprocessable_entity
      end
    end

    private

    def contact_params
      params.require(:contact).permit(:name, :email, :message)
    end
  end
end
