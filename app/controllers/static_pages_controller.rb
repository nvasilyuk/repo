# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :logged_in?, only: :home

  def home
    return root_url unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 14)
  end

  def help; end

  def about; end

  def contact; end
end
