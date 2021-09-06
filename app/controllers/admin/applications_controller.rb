class Admin::ApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
  end

  def update
    @app = Application.find(params[:id])
    @app.app_pet(params[:pet_id]).update(status: params[:status])
    redirect_to "/admin/applications/#{@app.id}"
  end

end
