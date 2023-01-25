module DogHelper
  include Pagy::Frontend

  def encount_dogs_at_this_entry(entry, dogrun_place_id)
    encount_dogs_created_at_this_entry = Encount.where(created_at: entry.entry_at .. entry.exit_at)
                                                .where(dogrun_place_id: dogrun_place_id)
                                                .where(user_id: @dog.user_id)
                                                .joins(:dog).where(dogs: { public: 'public_view' })
    @encount_dogs_at_this_entry = encount_dogs_created_at_this_entry.map do |encount|
      Dog.find(encount.dog_id)
    end
    return @encount_dogs_at_this_entry
  end

  def birthday_marker(dog)
    return if dog.birthday.blank?
    if dog.birthday.strftime('%m-%d') == Date.current.strftime('%m-%d')
      tag.svg class: "w-6 h-6 absolute inline-flex", fill: "#db2777", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
        tag.path "fill-rule": "evenodd", d: "M6 3a1 1 0 011-1h.01a1 1 0 010 2H7a1 1 0 01-1-1zm2 3a1 1 0 00-2 0v1a2 2 0 00-2 2v1a2 2 0 00-2 2v.683a3.7 3.7 0 011.055.485 1.704 1.704 0 001.89 0 3.704 3.704 0 014.11 0 1.704 1.704 0 001.89 0 3.704 3.704 0 014.11 0 1.704 1.704 0 001.89 0A3.7 3.7 0 0118 12.683V12a2 2 0 00-2-2V9a2 2 0 00-2-2V6a1 1 0 10-2 0v1h-1V6a1 1 0 10-2 0v1H8V6zm10 8.868a3.704 3.704 0 01-4.055-.036 1.704 1.704 0 00-1.89 0 3.704 3.704 0 01-4.11 0 1.704 1.704 0 00-1.89 0A3.704 3.704 0 012 14.868V17a1 1 0 001 1h14a1 1 0 001-1v-2.132zM9 3a1 1 0 011-1h.01a1 1 0 110 2H10a1 1 0 01-1-1zm3 0a1 1 0 011-1h.01a1 1 0 110 2H13a1 1 0 01-1-1z", "clip-rule": "evenodd"
      end
    else
      return
    end
  end

  def css_class_dog_color_marker_for_top(dog, current_user)
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

  def css_class_dog_color_marker(dog)
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

  def dog_thumbnail_for_top(dog, current_user)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker_for_top(dog, current_user), alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full mx-auto", alt: dog.name)
    end 
  end

  def dog_thumbnail(dog)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog), alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full mx-auto", alt: dog.name)
    end 
  end

  def dog_thumbnail_for_preview(dog)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_dog_color_marker(dog), alt: dog.name, "data-preview-target": "imagePreview")
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full mx-auto w-full h-full aspect-square object-cover", alt: dog.name, "data-preview-target": "imagePreview")
    end 
  end

  def encount_dog_thumbnail(dog, encount_dog)
    if dog.thumbnail.attached?
      cl_image_tag(dog.thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto, class: css_class_encount_dog_color_marker(encount_dog), alt: dog.name)
    else
      cl_image_tag('https://res.cloudinary.com/hryerpkcw/image/upload/v1668863628/j1leiksnvylye7rtun0r.png', gravity: :auto, quality_auto: :good, fetch_format: :auto, class: "rounded-full mx-auto", alt: dog.name)
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
      return tag.svg(class: "w-4 h-4 ml-2", "stroke-width": "2.11", viewBox: "0 0 24 24", fill: "none", xmlns: "http://www.w3.org/2000/svg", color: "#6366f1") { |tag| tag.path d: "M18 8.4c0-1.697-.632-3.325-1.757-4.525C15.117 2.675 13.59 2 12 2c-1.591 0-3.117.674-4.243 1.875C6.632 5.075 6 6.703 6 8.4 6 15.867 3 18 3 18h18s-3-2.133-3-9.6zM13.73 21a1.999 1.999 0 01-3.46 0", 
        stroke: "#6366f1", 
        "stroke-width": "3", 
        "stroke-linecap": "round", 
        "stroke-linejoin": "round" }
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
      return tag.svg(class: "w-5 h-5 ml-2 text-red-500", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg") { |tag| tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "3", d: "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" }
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
