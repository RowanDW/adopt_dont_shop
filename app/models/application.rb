class Application < ApplicationRecord
  has_many :application_pets, dependent: :destroy
  has_many :pets, through: :application_pets

  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  def show_pet_search?
    return true if app_status == "In Progress"
    false
  end

  def show_app_submit?
    return true if app_status == "In Progress" && pets.count > 0
    false
  end

  def app_pet(pet_id)
    application_pets.where(pet_id: pet_id).first
  end

  def pet_status(pet_id)
    app_pet(pet_id).status
  end

  def all_approved?
     return true if application_pets.where(status: ["Rejected", nil]).count == 0
     false
  end

  def all_decided?
    return true if application_pets.where(status: nil).count == 0
    false
  end
end
