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
      tag.svg(class: "mt-3 md:mt-0 w-5 h-5", "stroke-width": "1.69", viewBox: "0 0 24 24", fill: "none", xmlns: "http://www.w3.org/2000/svg", color: "#6366f1") { |tag| tag.path d: "M18 8.4c0-1.697-.632-3.325-1.757-4.525C15.117 2.675 13.59 2 12 2c-1.591 0-3.117.674-4.243 1.875C6.632 5.075 6 6.703 6 8.4 6 15.867 3 18 3 18h18s-3-2.133-3-9.6zM13.73 21a1.999 1.999 0 01-3.46 0", 
        stroke: "#6366f1", 
        "stroke-width": "3", 
        "stroke-linecap": "round", 
        "stroke-linejoin": "round" }
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
      return tag.svg(class: "mt-3 md:mt-0 w-5 h-5 ml-2 text-red-500", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24", xmlns: "http://www.w3.org/2000/svg") { |tag| tag.path "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "3", d: "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" }
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
    cl_image_path thumbnail.key, gravity: :auto, quality_auto: :good, fetch_format: :auto 
  end

  def rabies_vaccination_certificate_preview
    cl_image_path rabies_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto
  end

  def mixed_vaccination_certificate_preview
    cl_image_path mixed_vaccination_certificate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto
  end

  def license_plate_preview
    cl_image_path license_plate.key, gravity: :auto, quality_auto: :good, fetch_format: :auto
  end
end
