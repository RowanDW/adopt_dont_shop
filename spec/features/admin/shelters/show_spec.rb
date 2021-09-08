require 'rails_helper'

RSpec.describe "admin shelter show page" do

  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202", app_status: "Pending")

    @app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_1.id)
  end

  it "shows the name and city of each shelter" do
    visit "/admin/shelters/#{@shelter_1.id}"
    within('#attributes') do
      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_1.city)
    end
  end

  it "has a section for statistics with average age" do
    visit "/admin/shelters/#{@shelter_1.id}"

    within('#statistics') do
      expect(page).to have_content('Shelter Stats:')
      expect(page).to have_content('Average pet age: 4.33 years')
    end
  end

  it "shows count of adoptable pets in stats" do
    visit "/admin/shelters/#{@shelter_1.id}"

    within('#statistics') do
      expect(page).to have_content('Shelter Stats:')
      expect(page).to have_content('Average pet age: 4.33 years')
      expect(page).to have_content('Adoptable pets: 3')
    end
  end

  it "shows count of adopted pets in stats" do
    @application.update(app_status: "Approved")
    @pet_1.update(adoptable: false)
    visit "/admin/shelters/#{@shelter_1.id}"

    within('#statistics') do
      expect(page).to have_content('Shelter Stats:')
      expect(page).to have_content('Average pet age: 4.33 years')
      expect(page).to have_content('Adoptable pets: 2')
      expect(page).to have_content('Adopted pets: 1')
    end
  end
end
