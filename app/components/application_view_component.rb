class ApplicationViewComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include ApplicationHelper
  include DogHelper
  include SessionHelper
end
