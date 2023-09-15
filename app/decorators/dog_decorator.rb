module DogDecorator
  def age
    today = Time.zone.today
    this_years_birthday = Time.zone.local(today.year, birthday.month, birthday.day)
    age = today.year - birthday.year
    age -= 1 if today < this_years_birthday
    age
  end
  
  def notice_badge
    today = Date.current
    notice_period = 15
    notification = false

    if date_of_rabies_vaccination.present?
      rabies_one_year_later = date_of_rabies_vaccination + 365
      notice_start_date = rabies_one_year_later - notice_period
      if (today.after? notice_start_date) && (today.before? rabies_one_year_later)
        notification = true
      end
    end

    if date_of_mixed_vaccination.present?
      mixed_one_year_later = date_of_mixed_vaccination + 365
      notice_start_date = mixed_one_year_later - notice_period
      if (today.after? notice_start_date) && (today.before? mixed_one_year_later)
        notification = true
      end
    end

    if notification == true
      tag.svg(xmlns: "http://www.w3.org/2000/svg", class: "ml-2 w-5 h-5 text-blue-700", fill: "currentColor", viewBox:"0 0 448 512") { |tag| tag.path d: "M224 0c-17.7 0-32 14.3-32 32V51.2C119 66 64 130.6 64 208v18.8c0 47-17.3 92.4-48.5 127.6l-7.4 8.3c-8.4 9.4-10.4 22.9-5.3 34.4S19.4 416 32 416H416c12.6 0 24-7.4 29.2-18.9s3.1-25-5.3-34.4l-7.4-8.3C401.3 319.2 384 273.9 384 226.8V208c0-77.4-55-142-128-156.8V32c0-17.7-14.3-32-32-32zm45.3 493.3c12-12 18.7-28.3 18.7-45.3H224 160c0 17 6.7 33.3 18.7 45.3s28.3 18.7 45.3 18.7s33.3-6.7 45.3-18.7z" }
    else
      return
    end
  end

  def notice_message
    today = Date.current
    notice_period = 15
    rabies_notification = false
    mixed_notification = false

    if date_of_rabies_vaccination.present?
      rabies_one_year_later = date_of_rabies_vaccination + 365
      notice_start_date = rabies_one_year_later - notice_period
      if (today.after? notice_start_date) && (today.before? rabies_one_year_later)
        rabies_notification = true
      end
    end

    if date_of_mixed_vaccination.present?
      mixed_one_year_later = date_of_mixed_vaccination + 365
      notice_start_date = mixed_one_year_later - notice_period
      if (today.after? notice_start_date) && (today.before? mixed_one_year_later)
        mixed_notification = true
      end
    end

    if rabies_notification == true && mixed_notification != true
      simple_format(t('dogs.messages.notice_to_get_rabies_vaccination'), { class: "text-left text-blue-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    elsif rabies_notification != true && mixed_notification == true
      simple_format(t('dogs.messages.notice_to_get_mixed_vaccination'), { class: "text-left text-blue-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    elsif rabies_notification == true && mixed_notification == true
      simple_format(t('dogs.messages.notice_to_get_both_vaccinations'), { class: "text-left text-blue-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    else
      return
    end
  end

  def alart_badge
    today = Date.current
    notification = false

    if date_of_rabies_vaccination.present?
      rabies_one_year_later = date_of_rabies_vaccination + 365
      if today.after? rabies_one_year_later
        notification = true
      end
    end

    if date_of_mixed_vaccination.present?
      mixed_one_year_later = date_of_mixed_vaccination + 365
      if today.after? mixed_one_year_later
        notification = true
      end
    end

    if notification == true
      tag.svg(xmlns: "http://www.w3.org/2000/svg", class: "w-5 h-5 ml-2 text-red-700", fill: "currentColor", viewBox: "0 0 512 512") { |tag| tag.path d: "M256 32c14.2 0 27.3 7.5 34.5 19.8l216 368c7.3 12.4 7.3 27.7 .2 40.1S486.3 480 472 480H40c-14.3 0-27.6-7.7-34.7-20.1s-7-27.8 .2-40.1l216-368C228.7 39.5 241.8 32 256 32zm0 128c-13.3 0-24 10.7-24 24V296c0 13.3 10.7 24 24 24s24-10.7 24-24V184c0-13.3-10.7-24-24-24zm32 224a32 32 0 1 0 -64 0 32 32 0 1 0 64 0z" }
    else
      return
    end
  end

  def alart_message
    today = Date.current
    notice_period = 15
    rabies_notification = false
    mixed_notification = false

    if date_of_rabies_vaccination.present?
      rabies_one_year_later = date_of_rabies_vaccination + 365
      if today.after? rabies_one_year_later
        rabies_notification = true
      end
    end

    if date_of_mixed_vaccination.present?
      mixed_one_year_later = date_of_mixed_vaccination + 365
      if today.after? mixed_one_year_later
        mixed_notification = true
      end
    end

    if rabies_notification == true && mixed_notification != true
      simple_format(t('dogs.messages.alart_to_get_rabies_vaccination'), { class: "text-left text-red-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    elsif rabies_notification != true && mixed_notification == true
      simple_format(t('dogs.messages.alart_to_get_mixed_vaccination'), { class: "text-left text-red-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    elsif rabies_notification == true && mixed_notification == true
      simple_format(t('dogs.messages.alart_to_get_both_vaccinations'), { class: "text-left text-red-700 font-semibold text-sm" }, { wrapper_tag: "div" })
    else
      return
    end
  end

  def thumbnail_preview
    Cloudinary::Utils.cloudinary_url(thumbnail.key, gravity: :auto, quarity_auto: :good, fetch_format: :auto)
  end

  def rabies_vaccination_certificate_preview
    Cloudinary::Utils.cloudinary_url(rabies_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto)
  end

  def mixed_vaccination_certificate_preview
    Cloudinary::Utils.cloudinary_url(mixed_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto)
  end

  def license_plate_preview
    Cloudinary::Utils.cloudinary_url(license_plate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto)
  end
end
