class Admin::ApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
    if @app.all_approved?
      @app.update(app_status: "Approved")
      @app.pets.update_all(adoptable: false)
    elsif @app.all_decided?
      @app.update(app_status: "Rejected")
    end
  end

  def update
    @app = Application.find(params[:id])
    @app.app_pet(params[:pet_id]).update(status: params[:status])
    redirect_to "/admin/applications/#{@app.id}"
  end

end
