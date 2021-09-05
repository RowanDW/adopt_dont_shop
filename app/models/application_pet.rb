class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application


  def self.validate?(app_pet)
    return false if where(application_id: app_pet.application_id).where(pet_id: app_pet.pet_id).exists?
    true
  end
end
