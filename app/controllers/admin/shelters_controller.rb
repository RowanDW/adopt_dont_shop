class Admin::SheltersController < ApplicationController

  def index
    @shelters = Shelter.alph_desc
    @pending = Shelter.with_pending_apps
  end

  def show
    @shelter = Shelter.get_name_and_city(params[:id])
    @av_age = Shelter.find(params[:id]).av_age
  end
end
