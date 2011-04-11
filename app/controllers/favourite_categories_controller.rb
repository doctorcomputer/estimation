# To change this template, choose Tools | Templates
# and open the template in the editor.

class FavouriteCategoriesController < ApplicationController

  # Show the list of registered favourite categories.
  def index
    @fav_categories = FavouriteCategory \
      .where('user_id = :user_id', :user_id => current_user.id)
    @fav_category = FavouriteCategory.new
  end

  def create
    new_fav_category = FavouriteCategory.new(params[:favourite_category])
    new_fav_category.user = current_user
    @fav_category = FavouriteCategory.new
    if new_fav_category.save
      flash.now[:notice] = "La categoria è stata salvata come preferita."
      render :action => :index
    else
      flash.now[:error] = "La categoria non è stata salvata."
      render :action => :index
    end
  end

  def delete
    fav_category = FavouriteCategory.new(params[:favourite_category])
    fav_category.user = current_user
    if fav_category.save
      renedr :action => :index
    else
      renedr :action => :index
    end
  end

end
