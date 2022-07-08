class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: @contact.email,
      to: Rails.application.credentials.contacts[:MAILER_USER_ID],
      subject: t('.subject')
    )
  end
end
