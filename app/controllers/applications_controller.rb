class ApplicationsController < ApplicationController
  def show
    @app = Application.find(params[:id])
    if params[:pet_search].present?
      @pet_results = Pet.search(params[:pet_search])
    else
      @pet_results = []
    end
  end

  def new
  end

  def create
    application = Application.new(app_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to '/applications/new'
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(description: def_params, app_status: "Pending")
    redirect_to "/applications/#{application.id}"
  end

  private

  def app_params
    params.permit(:id, :name, :street_address, :city, :state, :zip_code)
  end

  def def_params
    params.permit(:description)
  end
end
