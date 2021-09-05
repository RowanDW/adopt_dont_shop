class Admin::SheltersController < ApplicationController

  def index
    @shelters = Shelter.alph_desc
  end
end
