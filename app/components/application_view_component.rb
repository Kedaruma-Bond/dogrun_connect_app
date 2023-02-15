class ApplicationViewComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Turbo::StreamsHelper
  include ApplicationHelper
  include DogHelper
  include SessionHelper
  include DogrunPlaceHelper
end
