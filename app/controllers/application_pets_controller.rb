class ApplicationPetsController < ApplicationController

  def create
    app_pet = ApplicationPet.new(app_pets_params)
    app_pet.save
    redirect_to "/applications/#{params[:application_id]}"
  end

  private
  def app_pets_params
    params.permit(:application_id, :pet_id)
  end
end
