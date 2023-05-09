class BusinessTimeMonitoringJob
  def call
    dogrun_places = DogrunPlace.where.not(opening_time: nil).where.not(closing_time: nil)
    dogrun_places.each do |dogrun_place|
      present_time_num = Time.zone.now.strftime('%Y%m%d%H%M').to_i
      case dogrun_place.closed_flag
      when true
        return if dogrun_place.force_closing?
        opening_time_num = Time.zone.parse("#{Time.zone.now.strftime('%Y-%m-%d')} #{dogrun_place.opening_time}").strftime('%Y%m%d%H%M').to_i
        if opening_time_num < present_time_num
          dogrun_place.update(closed_flag: false)
        else
          return
        end
      when false
        closing_time_num = Time.zone.parse("#{Time.zone.now.strftime('%Y-%m-%d')} #{dogrun_place.closing_time}").strftime('%Y%m%d%H%M').to_i
        if dogrun_place.force_closing? || closing_time_num < present_time_num
          dogrun_place.update(closed_flag: true) 
          entries = Entry.includes(:registration_number).where(registration_number: { dogrun_place_id: dogrun_place.id }).where(exit_at: nil)
          entries.each do |entry|
            entry.update(exit_at: Time.zone.now)
          end
        end
        return
      end
    end
  end
end
