

@shelter_1 = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
@shelter_2 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

@pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
@pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
@pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: true)
@pet_4 = @shelter_2.pets.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true)
@pet_5 = @shelter_2.pets.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true)

@application_1 = Application.create(name: "P. Sherman", street_address: "42 Wallaby way", city: "Denver", state: "CO", zip_code: "80202")
@application_2 = Application.create(name: "J. Biden", street_address: "1600 Pennsylvania Ave", city: "Washington", state: "D.C.", zip_code: "20500")

@app_pet_1 = ApplicationPet.create(application_id: @application_1.id, pet_id: @pet_1.id)
@app_pet_2 = ApplicationPet.create(application_id: @application_1.id, pet_id: @pet_2.id)
