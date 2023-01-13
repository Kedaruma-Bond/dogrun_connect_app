class PreEntryManagementJob
  def call
    PreEntry.all.each do |pre_entry|
      counter = pre_entry.minutes_passed_count
      counter += 1
      minutes_multiples_of_5 = 6
      if counter >=  minutes_multiples_of_5
        pre_entry.destroy
      else
        pre_entry.update(minutes_passed_count: counter)
      end
    end
  end
end
