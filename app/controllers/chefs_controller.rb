class ChefsController < ApplicationController

  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show, :new, :create]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @chefs = Chef.page(params[:page])
  end

  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      session[:chef_id] = @chef.id
      flash[:success] = "Welcome #{@chef.name} to my recipes app!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    @chef_recipes = @chef.recipes.page(params[:page])
  end

  def edit

  end

  def update
    if @chef.update(chef_params)
      flash[:succcess] = "Yout account was updated successfully!"
      redirect_to @chef
    else
      render 'edit'
    end
  end

  def destroy
    @chef.destroy
    flash[:danger] = "Chef and all associated recipes have been deleted!"
    redirect_to chefs_path
  end

  private

  def chef_params
    params.require(:chef).permit(:name, :email, :password,  :password_confirmation)
  end

  def set_chef
    @chef = Chef.find(params[:id])
  end

  def require_same_user
    if current_chef != @chef && !current_chef.admin?
      flash[:danger] = "You can only delete or update your own profile"
      redirect_to chefs_path
    end
  end

  def require_admin
    if logged_in? && !current_chef.admin?
      flash[:danger] = "Only admins users can perform that action"
      redirect_to root_path
    end
  end
  
end