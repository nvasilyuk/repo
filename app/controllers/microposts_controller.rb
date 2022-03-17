# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  # GET /microposts or /microposts.json
  def index
    @microposts = Micropost.all
  end

  # GET /microposts/1 or /microposts/1.json
  def show; end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit; end

  # POST /microposts or /microposts.json
  def create
    # @micropost = Micropost.new(micropost_params)
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = 'Micropost created!'
      # redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      flash[:danger] = "Micropost wasn't created! Probably it was empty or image has invalid format/size"
      # redirect_to root_url
      # render 'static_pages/home'
    end
    redirect_to root_url
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to micropost_url(@micropost), notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url

    # respond_to do |format|
    #   format.html { redirect_to root_url, notice: 'Micropost was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
