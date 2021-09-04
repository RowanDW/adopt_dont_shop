require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it {should have_many :application_pets}
    it {should have_many(:applications).through(:application_pets)}

  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202")
    @app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_1.id)
    @app_pet_2 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_2.id)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe '#pets_for_app' do
      it 'returns all pets on an application' do
        expect(Pet.pets_for_app(@application.id)).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end
end
