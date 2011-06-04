class StaticController < ApplicationController

  def index

    @search = Struct.new("Search", :query, :category_key).new("","")

    # find groups of interesting request that could be shown to the user.

    @expiring_requests = Request \
      .where('status = :status', :status => :active) \
      .where(':now<expiration', :now => DateTime.now) \
      .order("expiration ASC") \
      .limit(3)

    @newest_requests = Request \
      .where('status = :status', :status => :active) \
      .where(':now<expiration', :now => DateTime.now) \
      .order("created_at DESC") \
      .limit(3)

#    @uncared_requests = Request \
#      .joins(:proposals) \
#      .where('status = :status', :status => :active) \
#      .where(':now<expiration', :now => DateTime.now) \
#      .limit(3)

    #This could be used to extract request without offers
    #SELECT requests.*, count(proposals.request_id) FROM requests JOIN proposals on requests.id=proposals.request_id
    #WHERE requests.status = 'active'
    #GROUP BY proposals.request_id
    #HAVING count(proposals.request_id) = 0
      
  end

  def how_it_works
    
  end

  def terms_of_service
    
  end

  def privacy_note
    
  end

  def site_map
    
  end

end
