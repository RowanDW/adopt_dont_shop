class Admin::SheltersController < ApplicationController

  def index
    @shelters = Shelter.alph_desc
    @pending = Shelter.with_pending_apps
  end

  def show
    @shelter_sql = Shelter.get_name_and_city(params[:id])
    @shelter = Shelter.find(params[:id])
  end
end
