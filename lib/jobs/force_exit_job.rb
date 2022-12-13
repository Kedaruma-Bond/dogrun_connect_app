class ForceExitJob
  def call
    entries = Entry.where(exit_at: nil)
    entries.each do |entry|
      entry.update(exit_at: Time.zone.now)
      @entry = entry
      registration_number = RegistrationNumber.find(entry.registration_number_id)
      @dogrun = DogrunPlace.find(registration_number.dogrun_place_id)
      @dog = Dog.find(registration_number.dog_id)
      @user = User.find(@dog.user_id)
      UserMailer.force_exit_notification(@user,@dog,@dogrun).deliver_now
    end
  end
end
