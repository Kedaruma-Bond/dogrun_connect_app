require 'active_support'

module PostConcern
  extend ActiveSupport::Concern

  def send_notification_mail(staffs)
    @staffs = staffs
    unless @staffs.blank? then
      n = 0
      @dogrun_place = DogrunPlace.find(@staffs[0].dogrun_place_id)
      @staffs.size.times do
        PostMailer.post_notification(@staffs[n], @dogrun_place).deliver_now
        n += 1
      end
    end
    return
  end
end
