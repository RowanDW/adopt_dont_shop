require 'rails_helper'

RSpec.describe "admin shelter index page" do

  before :each do
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202", app_status: "Pending")

    @app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_1.id)
  end

  it "shows each shelter" do
    visit '/admin/shelters'

    within('#all_shelters') do
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end
  end

  it 'shows a shelters with pending applications section' do
    visit '/admin/shelters'

    within('#pending') do
      expect(page).to have_content("Shelters with Pending Applications")
      expect(page).to have_content('Aurora shelter')
      expect(page).to_not have_content('RGV animal shelter')
      expect(page).to_not have_content('Fancy pets of Colorado')
    end
  end

  it 'shelters with pending applications are in alphabetical order' do
    app_pet_2 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_3.id)
    visit '/admin/shelters'

    within('#pending') do

      expect(page).to have_content('Aurora shelter')
      expect(page).to have_content('Fancy pets of Colorado')
      expect(@shelter_1.name).to appear_before(@shelter_3.name)
    end
  end

end
