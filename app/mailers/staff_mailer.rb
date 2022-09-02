class StaffMailer < ApplicationMailer
  def staff_registration_success(staff, dogrun_place)
    @staff = staff
    @dogrun_place = dogrun_place
    mail(
      from: Rails.application.credentials.users[:MAILER_USER_ID],
      to: @staff.email
      subject: t('.subject', dogrun_name: @dogrun_place.name)
    )
  end
end
