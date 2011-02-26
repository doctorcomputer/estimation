class StaticController < ApplicationController

  def index
    @search = Struct.new("Search", :query, :category_key).new("","")
  end

  def how_it_works
    
  end

  def terms_of_service
    
  end

  def privacy_note
    
  end

end
