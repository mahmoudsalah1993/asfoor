class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page]) 
  end

  def show 
    @user = User.find(params[:id])
    @request = Request.new
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome the Asfoor!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Successfully Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  def search
    @user = User.new
    @user.name="name"
    render 'search'
  end
  def result
    #@u = User.where(name: user_params[:name])
    #Question.where("content LIKE ?" , "%#{farming}%")
    @users_name = User.where("name=?", user_params[:name])
    @users_email = User.where("email=?", user_params[:name])
    @users_last = User.where("last_name=?", user_params[:name])
    @users_phone = User.where("phone=?", user_params[:name])
    @user_post = User.find(session[:user_id]).microposts.where("content LIKE ?","%#{user_params[:name]}%");
    render 'search_result'
  end
  def search_result
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end  

  def requesters
    @title = "Friends Requests"
    @user  = User.find(params[:id])
    @users = @user.requesters.paginate(page: params[:page])
    render 'show_request'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,:password_confirmation,
                      :last_name,:phone,:gender,:birthdate,:hometown,:about_me,:marital_status,
                      :profile_picture)

    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)    end

    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
