namespace :create_facility_task do
  desc "dogrun_placeの設備名称を作成"
  task create_facility_items: :environment do
    Facility.create([
      { name: I18n.t('facility.name.drinking_fountains') },
      { name: I18n.t('facility.name.shower') },
      { name: I18n.t('facility.name.waste_bin') },
      { name: I18n.t('facility.name.poop_bag') },
      { name: I18n.t('facility.name.deodorant_spray') },
      { name: I18n.t('facility.name.store') },
      { name: I18n.t('facility.name.registration_not_required') }
    ])
  end
end
