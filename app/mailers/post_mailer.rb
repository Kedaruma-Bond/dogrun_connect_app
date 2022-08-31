class PostMailer < ApplicationMailer
  def post_notification(staffs)
    @staffs = staffs
    mail(
      from: Rails.application.credentials[:MAILER_USER_ID],
      to: @staffs.email,
      subject: t('.subject')
    )

  end
end
