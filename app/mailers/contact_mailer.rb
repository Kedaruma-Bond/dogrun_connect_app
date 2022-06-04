class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail(
      from: @contact.email,
      to: Rails.application.credentials.contacts[:MAILER_USER_ID],
      subject: '[お問い合わせ]'
    )
  end
end
