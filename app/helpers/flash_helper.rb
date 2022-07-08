module FlashHelper
  def css_class_for_flash(flash_key)
    case flash_key.to_sym
    when :error
      'bg-red-100 text-red-700'
    when :success
      'bg-green-100 text-green-700'
    else
      'bg-blue-100 text-blue-700'
    end
  end
end
