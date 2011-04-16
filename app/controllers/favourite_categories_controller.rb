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

end
