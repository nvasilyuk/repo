class AccountActivationsController < ApplicationController
  before_action :user, only: :edit

  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = 'Account activated!'
      redirect_to @user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  private

  def user
    @user ||= User.find_by(email: params[:email])
  end

end
