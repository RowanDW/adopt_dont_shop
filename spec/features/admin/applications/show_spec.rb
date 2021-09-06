require 'rails_helper'

RSpec.describe "admin shelter show page" do

  before :each do
    @shelter_1 = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create!(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create!(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create!(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create!(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create!(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create!(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202", app_status: "Pending")

    @app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_1.id)
    @app_pet_2 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_2.id)
  end

  it "can approve pets on an application" do

    visit "/admin/applications/#{@application.id}"

    expect(page).to have_content('Mr. Pirate')
    expect(page).to have_button('Approve Mr. Pirate')
    expect(page).to have_content('Clawdia')
    expect(page).to have_button('Approve Clawdia')

    click_button 'Approve Mr. Pirate'
    save_and_open_page
    expect(current_path).to eq("/admin/applications/#{@application.id}")
    expect(page).to_not have_button('Approve Mr. Pirate')
    expect(page).to have_content('Mr. Pirate - Approved')
  end

end
