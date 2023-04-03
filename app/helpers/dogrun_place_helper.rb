module DogrunPlaceHelper
  include Pagy::Frontend
  
  def dogrun_top_path(id)
    case id
    when 2
      togo_inu_shitsuke_hiroba_top_path
    when 3
      reon_top_path
    end
  end

  def dogrun_logo(dogrun_place)
    if dogrun_place.logo.attached?
      cl_image_tag(dogrun_place.logo.key, quality_auto: :good, fetch_format: :auto, class: "w-full h-auto", alt: dogrun_place.name)
    else
      image_tag 'app_icon.png', class: "w-full h-auto", alt: "dogrunconnect_logo"
    end
  end

  def dogrun_logo_for_preview(dogrun_place)
    if dogrun_place.logo.attached?
      cl_image_tag(dogrun_place.logo.key, quality_auto: :good, fetch_format: :auto, class: "w-full h-auto", alt: dogrun_place.name, "data-preview-target": "imagePreview")
    else
      image_tag 'app_icon.png', class: "w-full h-auto", alt: "dogrunconnect_logo", "data-preview-target": "imagePreview"
    end
  end

  def registration_card(dogrun_place)
    cl_image_tag(dogrun_place.registration_card.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, alt: "preview of registration card", class: "object-cover rounded mx-auto md:mx-0 h-auto w-20")
  end
  
  def registration_card_for_preview(dogrun_place)
    if dogrun_place.registration_card.attached?
      cl_image_tag(dogrun_place.registration_card.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, "data-preview-target": "imagePreview", alt: "preview of registration card", class: "object-cover rounded mx-auto md:mx-0 h-auto w-40")
    else
      # 小さい画像ファイルを表示させておき、添付画像と差し替える
      image_tag 'data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', "data-preview-target": "imagePreview"
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
