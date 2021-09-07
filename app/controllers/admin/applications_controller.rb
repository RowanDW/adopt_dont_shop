class Admin::ApplicationsController < ApplicationController

  def show
    @app = Application.find(params[:id])
    if @app.app_status == "Pending" && @app.all_approved?
      @app.update(app_status: "Approved")
    end
  end

  def update
    @app = Application.find(params[:id])
    @app.app_pet(params[:pet_id]).update(status: params[:status])
    redirect_to "/admin/applications/#{@app.id}"
  end

end
