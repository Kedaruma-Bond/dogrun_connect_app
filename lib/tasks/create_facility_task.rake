namespace :create_facility_task do
  desc "dogrun_placeの設備名称を作成"
  task create_facility_items: :environment do
    Facility.create([
      { name: 'drinking_fountains' },
      { name: 'shower' },
      { name: 'waste_bin' },
      { name: 'poop_bag' },
      { name: 'deodorant_spray' },
      { name: 'store' },
      { name: 'registration_not_required' }
    ])
  end
end
