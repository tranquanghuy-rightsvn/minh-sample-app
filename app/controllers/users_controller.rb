class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per 10
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = I18n.t ".messages.user.welcome"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = I18n.t ".messages.user.profile"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t ".messages.user.deleted"
    redirect_to users_url
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = I18n.t ".messages.user.login"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
