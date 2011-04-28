# To change this template, choose Tools | Templates
# and open the template in the editor.

class FavouriteCategoriesController < ApplicationController

  def init_page_attributes
    @fav_category = FavouriteCategory.new
    @fav_categories = FavouriteCategory \
      .where('user_id = :user_id', :user_id => current_user.id)
    @fav_category_keys = @fav_categories.collect{ |cat| cat.category }
  end

  # Show the list of registered favourite categories.
  def index
    init_page_attributes
  end

  def create
    new_fav_category = FavouriteCategory.new(params[:favourite_category])
    new_fav_category.user = current_user
    if new_fav_category.save
      flash.now[:notice] = "La categoria è stata salvata come preferita."
    else
      flash.now[:error] = "La categoria non è stata salvata."
    end
    init_page_attributes
    render :action => :index
  end

  def destroy
    fav_category = FavouriteCategory.find(params[:id])
    if fav_category.user == current_user && !fav_category.nil?
      if fav_category.delete
        flash.now[:notice] = "La categoria è stata rimossa dalle preferite."
      else
        flash.now[:error] = "La categoria non è stata rimossa."
      end
    end
    init_page_attributes
    render :action => :index
  end

  def interesting_requests
    fav_categories = FavouriteCategory.where('user_id = :user_id', :user_id => current_user.id)
    unless fav_categories.nil?

      sorting = {
        'expiring_asc' => 'expiration asc',
        'published_desc' => 'updated_at desc',
        nil => 'expiration asc'
      }

      fav_category_keys = fav_categories.collect{ |cat| cat.category }
      @requests = Request \
        .where('status=:status AND :now<expiration', :status => :active, :now => DateTime.now) \
        .where(:category_id => fav_category_keys) \
        .where('user_id <> :user', :user => current_user.id) \
        .order(sorting[params[:sorting]]) \
        .paginate( :page => params[:page], :per_page => 10 )
    else
      @requests = nil
    end
  end

end
