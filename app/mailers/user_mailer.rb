class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: user.email,
      subject: t('.subject')
    )
  end

  def user_registration_success(user)
    @user = user
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @user.email,
      subject: t('.subject')
    )
  end
end
