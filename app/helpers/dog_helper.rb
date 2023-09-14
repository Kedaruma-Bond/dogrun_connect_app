module DogHelper
  include Pagy::Frontend

  def encounts_at_this_entry(entry, dogrun_place)
    encounts_created_at_this_entry = Encount.where(created_at: entry.entry_at .. entry.exit_at)
                                            .where(dogrun_place_id: dogrun_place.id)
                                            .where(user_id: entry.dog.user_id)
                                            .joins(:dog).where(dogs: { public: 'public_view' })

    @encounts_at_this_entry = encounts_created_at_this_entry.map do |encount|
      Dog.find(encount.dog_id)
    end

    return @encounts_at_this_entry
  end

  def birthday_marker(dog)
    return if dog.birthday.blank?
    if dog.birthday.strftime('%m-%d') == Date.current.strftime('%m-%d')
      render partial: "shared/birthday"
    else
      return
    end
  end

  def css_class_dog_color_marker(dog, current_user)
    encount_dog = EncountDog.where(user_id: current_user.id).find_by(dog_id: dog.id)
    return 'rounded-full w-full h-full aspect-square object-cover' if encount_dog.blank?

    case encount_dog.color_marker
    when 'red'
      'border-2 border-red-500 rounded-full w-full h-full aspect-square object-cover'
    when 'green'
      'border-2 border-green-400 rounded-full w-full h-full aspect-square object-cover'
    when 'blue'
      'border-2 border-blue-500 rounded-full w-full h-full aspect-square object-cover'
    when 'yellow'
      'border-2 border-yellow-500 rounded-full w-full h-full aspect-square object-cover'
    else
      'rounded-full w-full h-full aspect-square object-cover'
    end
  end

  def css_class_encount_dog_color_marker(encount_dog)
    case encount_dog.color_marker
    when 'red'
      'border-2 border-red-500 rounded-full w-full h-full aspect-square object-cover'
    when 'green'
      'border-2 border-green-400 rounded-full w-full h-full aspect-square object-cover'
    when 'blue'
      'border-2 border-blue-500 rounded-full w-full h-full aspect-square object-cover'
    when 'yellow'
      'border-2 border-yellow-500 rounded-full w-full h-full aspect-square object-cover'
    else
      'rounded-full w-full h-full aspect-square object-cover'
    end
  end

  def dog_thumbnail(dog, current_user)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog, current_user), alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog, current_user), alt: dog.name)
    end 
  end

  def dog_thumbnail_for_preview(dog, current_user)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog, current_user), alt: dog.name, "data-preview-target": "imagePreview")
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog, current_user), alt: dog.name, "data-preview-target": "imagePreview")
    end 
  end

  def dog_thumbnail_for_admin(dog)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full w-full h-full aspect-square object-cover", alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full w-full h-full aspect-square object-cover", alt: dog.name)
    end 
  end

  def encount_dog_thumbnail(dog, encount_dog)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_encount_dog_color_marker(encount_dog), alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_encount_dog_color_marker(encount_dog), alt: dog.name)
    end
  end

  def notice_inform_badge
    user_dogs = Dog.where(user: current_user)
    today = Date.current
    notice_period = 15
    notification = false

    user_dogs.each do |dog|
      if dog.date_of_rabies_vaccination.present?
        rabies_one_year_later = dog.date_of_rabies_vaccination + 365
        notice_start_date = rabies_one_year_later - notice_period
        if (today.after? notice_start_date) && (today.before? rabies_one_year_later)
          notification = true
          break
        end 
      end

      if dog.date_of_mixed_vaccination.present?
        mixed_one_year_later = dog.date_of_mixed_vaccination + 365
        notice_start_date = mixed_one_year_later - notice_period
        if (today.after? notice_start_date) && (today.before? mixed_one_year_later)
          notification = true
          break
        end
      end
    end

    if notification == true
      return tag.svg(xmlns: "http://www.w3.org/2000/svg", class: "ml-2 w-5 h-5 text-blue-700", fill: "currentColor", viewBox:"0 0 448 512") { |tag| tag.path d: "M224 0c-17.7 0-32 14.3-32 32V51.2C119 66 64 130.6 64 208v18.8c0 47-17.3 92.4-48.5 127.6l-7.4 8.3c-8.4 9.4-10.4 22.9-5.3 34.4S19.4 416 32 416H416c12.6 0 24-7.4 29.2-18.9s3.1-25-5.3-34.4l-7.4-8.3C401.3 319.2 384 273.9 384 226.8V208c0-77.4-55-142-128-156.8V32c0-17.7-14.3-32-32-32zm45.3 493.3c12-12 18.7-28.3 18.7-45.3H224 160c0 17 6.7 33.3 18.7 45.3s28.3 18.7 45.3 18.7s33.3-6.7 45.3-18.7z" }
    else
      return
    end
  end

  def alart_inform_badge
    user_dogs = Dog.where(user: current_user)
    today = Date.current
    notification = false

    user_dogs.each do |dog|
      if dog.date_of_rabies_vaccination.present?
        rabies_one_year_later = dog.date_of_rabies_vaccination + 365
        if today.after? rabies_one_year_later
          notification = true
          break
        end
      end

      if dog.date_of_mixed_vaccination.present?
        mixed_one_year_later = dog.date_of_mixed_vaccination + 365
        if today.after? mixed_one_year_later
          notification = true
          break
        end
      end
    end

    if notification == true
      return tag.svg(xmlns: "http://www.w3.org/2000/svg", class: "w-5 h-5 ml-2 text-red-700", fill: "currentColor", viewBox: "0 0 512 512") { |tag| tag.path d: "M256 32c14.2 0 27.3 7.5 34.5 19.8l216 368c7.3 12.4 7.3 27.7 .2 40.1S486.3 480 472 480H40c-14.3 0-27.6-7.7-34.7-20.1s-7-27.8 .2-40.1l216-368C228.7 39.5 241.8 32 256 32zm0 128c-13.3 0-24 10.7-24 24V296c0 13.3 10.7 24 24 24s24-10.7 24-24V184c0-13.3-10.7-24-24-24zm32 224a32 32 0 1 0 -64 0 32 32 0 1 0 64 0z" }
    else
      return
    end
  end
  
  def rabies_vaccination_certificate_form_preview(dog)
    if dog.rabies_vaccination_certificate.attached?
      cl_image_tag(dog.rabies_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "object-cover rounded mx-auto md:mx-0 h-auto w-full", alt: "rabies vaccination certificate", "data-preview-target": "imagePreview")
    else
      image_tag('data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded", "data-preview-target": "imagePreview")
    end 
  end
  
  def mixed_vaccination_certificate_form_preview(dog)
    if dog.mixed_vaccination_certificate.attached?
      cl_image_tag(dog.mixed_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "object-cover rounded mx-auto md:mx-0 h-auto w-full", alt: "rabies vaccination certificate", "data-preview-target": "imagePreview")
    else
      image_tag('data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded", "data-preview-target": "imagePreview")
    end 
  end
  
  def license_plate_form_preview(dog)
    if dog.license_plate.attached?
      cl_image_tag(dog.license_plate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "object-cover rounded mx-auto md:mx-0 h-auto w-full", alt: "rabies vaccination certificate", "data-preview-target": "imagePreview")
    else
      image_tag('data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded", "data-preview-target": "imagePreview")
    end 
  end
end
