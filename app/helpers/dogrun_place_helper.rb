module DogrunPlaceHelper
  def dogrun_logo(dogrun_place)
    if dogrun_place.logo.attached?
      cl_image_tag(dogrun_place.logo.key, quality_auto: :good, fetch_format: :auto, class: "w-full h-auto", alt: dogrun_place.name)
    else
      image_tag 'dogrun_logo.png', class: "w-full h-auto", alt: "dogrunconnect_logo"
    end
  end

  def dogrun_logo_for_preview(dogrun_place)
    if dogrun_place.logo.attached?
      cl_image_tag(dogrun_place.logo.key, quality_auto: :good, fetch_format: :auto, class: "w-full h-auto", alt: dogrun_place.name, "data-preview-target": "imagePreview")
    else
      image_tag 'dogrun_logo.png', class: "w-full h-auto", alt: "dogrunconnect_logo", "data-preview-target": "imagePreview"
    end
  end

  def dogrun_facility_view(name)
    case name
    when 'drinking_fountains'
      t('facility.name.drinking_fountains')
    when 'shower'
      t('facility.name.shower')
    when 'waste_bin'
      t('facility.name.waste_bin')
    when 'poop_bag'
      t('facility.name.poop_bag')
    when 'deodorant_spray'
      t('facility.name.deodorant_spray') 
    when 'store'
      t('facility.name.store')  
    when 'registration_not_required'
      t('facility.name.registration_not_required')   
    end
  end

end
