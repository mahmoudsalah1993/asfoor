class RequestsController < ApplicationController
	before_action :logged_in_user

  def create
    @user = User.find(params[:requested_id])
    current_user.friend_request(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Request.find(params[:id]).requested
    current_user.cancel_friend_request(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
