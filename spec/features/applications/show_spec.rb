require 'rails_helper'

RSpec.describe "application show page" do

  before :each do
    @shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @scooby = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @salem = Pet.create(name: 'Salem', age: 16, breed: 'Cat', adoptable: true, shelter_id: @shelter.id)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202")
  end

  it "shows the application and all attributes" do
    app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @scooby.id)
    app_pet_2 = ApplicationPet.create!(application_id: @application.id, pet_id: @salem.id)

    visit "/applications/#{@application.id}"

    expect(page).to have_content(@application.name)
    expect(page).to have_content(@application.street_address)
    expect(page).to have_content(@application.city)
    expect(page).to have_content(@application.state)
    expect(page).to have_content(@application.zip_code)
    expect(page).to have_content(@application.description)

    expect(page).to have_content("Pets:")
    expect(page).to have_link("#{@scooby.name}")
    expect(page).to have_link("#{@salem.name}")
    expect(page).to have_content(@application.app_status)

    click_link "#{@scooby.name}"
    expect(current_path).to eq("/pets/#{@scooby.id}")

    visit "/applications/#{@application.id}"

    click_link "#{@scooby.name}"
    expect(current_path).to eq("/pets/#{@scooby.id}")
  end

  it "shows an add pet section if app is in progress" do
    visit "/applications/#{@application.id}"

    expect(page).to have_content("Add a Pet to this Application")

    fill_in "Pet search", with: "Scooby"
    click_button 'Search'

    expect(current_path).to eq("/applications/#{@application.id}")
    expect(page).to have_content("Scooby")
  end

end
