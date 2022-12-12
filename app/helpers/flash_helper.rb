module FlashHelper
  def css_class_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      'bg-red-500'
    when :success
      'bg-emerald-500'
    else
      'bg-blue-500'
    end
  end
  
  def icon_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      tag.svg class: "w-6 h-6 text-white fill-current", viewBox: "0 0 40 40", xmlns: "http://www.w3.org/2000/svg" do 
        tag.path d:"M20 3.33331C10.8 3.33331 3.33337 10.8 3.33337 20C3.33337 29.2 10.8 36.6666 20 36.6666C29.2 36.6666 36.6667 29.2 36.6667 20C36.6667 10.8 29.2 3.33331 20 3.33331ZM21.6667 28.3333H18.3334V25H21.6667V28.3333ZM21.6667 21.6666H18.3334V11.6666H21.6667V21.6666Z"
      end
    when :success
      tag.svg class: "w-6 h-6 text-white fill-current", viewBox: "0 0 40 40", xmlns: "http://www.w3.org/2000/svg" do
        tag.path d: "M20 3.33331C10.8 3.33331 3.33337 10.8 3.33337 20C3.33337 29.2 10.8 36.6666 20 36.6666C29.2 36.6666 36.6667 29.2 36.6667 20C36.6667 10.8 29.2 3.33331 20 3.33331ZM16.6667 28.3333L8.33337 20L10.6834 17.65L16.6667 23.6166L29.3167 10.9666L31.6667 13.3333L16.6667 28.3333Z"
      end
    else
      tag.svg class: "w-6 h-6 text-white fill-current", viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg" do
        tag.path d: "M10 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 004 14h12a1 1 0 00.707-1.707L16 11.586V8a6 6 0 00-6-6zM10 18a3 3 0 01-3-3h6a3 3 0 01-3 3z"
      end
    end
  end
  
  def text_css_class_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      'text-red-500 dark:text-red-400'
    when :success
      'text-emerald-500 dark:text-emerald-400'
    else
      'text-blue-500 dark:text-blue-400'
    end
  end

  def main_message_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      "Error"
    when :success
      "Success"
    else
      "Info"
    end
  end

end
