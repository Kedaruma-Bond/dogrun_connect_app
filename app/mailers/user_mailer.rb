class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find user.id
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: user.email,
      subject: t('.subject')
    )
  end

  def user_registrated_success(user)
    @user = user
    @url  = togo_inu_shitsuke_hiroba_login_url
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @user.email,
      subject: t('.subject')
    )
  end
end
