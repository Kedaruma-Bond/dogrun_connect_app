class PostMailer < ApplicationMailer
  def post_notification(staff, dogrun_place)
      @staff = staff
      @dogrun_place = dogrun_place
      mail(
        from: Rails.application.credentials.users[:MAILER_USER_ID],
        to: @staff.email,
        subject: t('.subject')
      )
  end

  def publish_notification(user, dogrun_place)
    @user = user
    @dogrun_place = dogrun_place
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @user.email,
      subject: t('.subject')
    )
  end
end
