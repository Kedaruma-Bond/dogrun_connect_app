class CalendarInput < SimpleForm::Inputs::Base
  def input
    content_tag(@builder.date_field(attribute_name, input_html_options))
  end
end
