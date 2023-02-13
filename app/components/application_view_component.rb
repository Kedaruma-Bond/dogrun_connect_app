class ApplicationViewComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include ApplicationHelper
  include DogHelper
  include SessionHelper
  include AbstractController::Rendering
  include Dry::Effects.Reader(:current_user, default: nil)
end
