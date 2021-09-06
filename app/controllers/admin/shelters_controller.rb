class Admin::SheltersController < ApplicationController

  def index
    @shelters = Shelter.alph_desc
    @pending = Shelter.with_pending_apps
  end
end
