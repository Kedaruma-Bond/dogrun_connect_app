class RegistrationNumber < ApplicationRecord
  belongs_to :dog

  enum dogrun_place: { togo_inu_shitsuke_hiroba: 0, dog_with: 1 }
end
