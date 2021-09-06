require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it {should have_many :application_pets}
    it {should have_many(:pets).through(:application_pets)}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
  end

  describe "instance methods" do

    before :each do
      @shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      @scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
      @salem = Pet.create!(name: 'Salem', age: 16, breed: 'Cat', adoptable: true, shelter_id: @shelter.id)

      @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
        city: "Denver", state: "CO", zip_code: "80202")

      @application_2 = Application.create!(name: "Wall-e", street_address: "42 Wallaby way",
        city: "Denver", state: "CO", zip_code: "80202", app_status: "Pending")

      @application_3 = Application.create!(name: "Kyle", street_address: "42 Wallaby way",
        city: "Denver", state: "CO", zip_code: "80202")
    end

    describe '#show_pet_search?' do
      it "can determine if pet search should show" do
        expect(@application.show_pet_search?).to be true
        expect(@application_2.show_pet_search?).to be false
      end
    end

    describe '#show_app_submit?' do
      it "can determine if app submit should show" do
        expect(@application_3.show_app_submit?).to be false

        app_pet_1 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @scooby.id)

        expect(@application_3.show_app_submit?).to be true
      end
    end

    describe '#app_pet' do
      it 'finds the app_pet record for the pet and application' do
        app_pet_1 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @scooby.id)
        expect(@application_3.app_pet(@scooby.id)).to eq(app_pet_1)
      end
    end

    describe '#pet_status' do
      it 'finds the status of the app_pet' do
        app_pet_1 = ApplicationPet.create!(application_id: @application_3.id, pet_id: @scooby.id)
        expect(@application_3.pet_status(@scooby.id)).to eq(nil)
      end
    end
  end
end
