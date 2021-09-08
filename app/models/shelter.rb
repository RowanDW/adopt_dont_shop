class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.alph_desc
    find_by_sql('SELECT * FROM shelters ORDER BY name DESC')
  end

  def self.with_pending_apps
    select("shelters.*").
    joins(pets: :applications).
    where('applications.app_status = ?', "Pending").
    order("shelters.name").
    distinct
    #includes(:pets).where(pets: {app_status: "Pending"})
  end

  def self.get_name_and_city(shelt_id)
    find_by_sql("SELECT shelters.name, shelters.city FROM shelters WHERE shelters.id = #{shelt_id}").first
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def av_age
    pets.average(:age).to_f.round(2)
  end
end
