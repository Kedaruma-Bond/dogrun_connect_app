module TogoInuShitsukeHiroba
  class ContactMailer < ApplicationMailer
    def send_mail(contact)
      @contact = contact
      mail(
        to: Rails.application.credentials.contacts[:TOMAIL],
        subject: '[お問い合わせ]'
      )
    end
  end
end
