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
end
