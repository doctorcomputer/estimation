class StaticController < ApplicationController

  def index
    @search = Struct.new("Search", :query, :category_key).new("","")
  end

  def how_it_works
    
  end

end
