require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe "relationships" do
    it {should belong_to :application}
    it {should belong_to :pet}
  end

  before :each do
    @shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    @scooby = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
    @salem = Pet.create(name: 'Salem', age: 16, breed: 'Cat', adoptable: true, shelter_id: @shelter.id)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202")
  end

  it "validate?" do
    app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @scooby.id)
    app_pet_2 = ApplicationPet.new(application_id: @application.id, pet_id: @scooby.id)
    app_pet_3 = ApplicationPet.new(application_id: @application.id, pet_id: @salem.id)

    expect(ApplicationPet.validate?(app_pet_2)).to be false
    expect(ApplicationPet.validate?(app_pet_3)).to be true
  end
end
