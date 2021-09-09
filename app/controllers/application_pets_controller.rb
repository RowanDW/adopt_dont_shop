class ApplicationPetsController < ApplicationController

  def create
    app_pet = ApplicationPet.new(app_pets_params)

    if ApplicationPet.validate?(app_pet)
      app_pet.save
      redirect_to "/applications/#{params[:application_id]}"
    else
      redirect_to "/applications/#{params[:application_id]}"
      flash[:alert] = "Error: Pet already added to application"
    end
  end

  private
  def app_pets_params
    params.permit(:application_id, :pet_id, :status)
  end
end
