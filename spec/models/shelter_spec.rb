require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application = Application.create!(name: "P. Sherman", street_address: "42 Wallaby way",
      city: "Denver", state: "CO", zip_code: "80202", app_status: "Pending")

    @app_pet_1 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_2.id, status: "Pending")
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#alph_desc' do
      it 'orders the shelters alphabetically descending' do
        expect(Shelter.alph_desc).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#with_pending_apps' do
      it 'returns shelters with pending applications' do
        expect(Shelter.with_pending_apps).to eq([@shelter_1])
      end
    end

    describe '#get_name_and_city' do
      it "finds the name and city of the shelter" do
        shelter = Shelter.get_name_and_city(@shelter_1.id)
        expect(shelter.name).to eq('Aurora shelter')
        expect(shelter.city).to eq('Aurora, CO')
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.av_age' do
      it "returns the average age of all the pets at the shelter" do
        expect(@shelter_1.av_age).to eq(4.33)
        expect(@shelter_3.av_age).to eq(8)
      end
    end

    describe '.adoptable_count' do
      it "returns the number of adoptable pets at the shelter" do
        expect(@shelter_1.adoptable_count).to eq(2)
        expect(@shelter_3.adoptable_count).to eq(1)
        expect(@shelter_2.adoptable_count).to eq(0)
      end
    end

    describe '.adopted_count' do
      it "returns the number of adoptable pets at the shelter" do
        @application.update(app_status: "Approved")
        @pet_2.update(adoptable: false)

        expect(@shelter_1.adopted_count).to eq(1)
        expect(@shelter_2.adopted_count).to eq(0)
        expect(@shelter_3.adopted_count).to eq(0)
      end
    end

    describe '.action_required' do
      it "returns list of pets pending a decision at the shelter" do
        app_pet_2 = ApplicationPet.create!(application_id: @application.id, pet_id: @pet_4.id, status: "Pending")

        expect(@shelter_1.action_required).to eq([@pet_2, @pet_4])
        app_pet_2.update(status: "Approved")

        expect(@shelter_1.action_required).to eq([@pet_2])
      end
    end
  end
end
