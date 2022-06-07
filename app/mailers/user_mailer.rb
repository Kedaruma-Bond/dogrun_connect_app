class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
  end
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_needed_email.subject
  #
  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(@user.activation_token)
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @user.email,
      subject: t('.subject')
    )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation_success_email.subject
  #
  def activation_success_email(user)
    @user = user
    @url  = login_url
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @user.email,
      subject: t('.subject')
    )
  end
end
