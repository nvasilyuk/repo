class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_micropost, only: :destroy

  def index
    @microposts = Micropost.all
  end

  def show; end

  def new
    @micropost = Micropost.new
  end

  def edit; end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = 'Micropost created!'
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      flash[:danger] = "Micropost wasn't created! Probably it was empty or image has invalid format/size"
    end
    redirect_to root_url
  end

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

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_micropost
    @micropost = current_user.microposts.find_by(id: params[:id])
    if @micropost.nil?
      redirect_to root_url
      flash[:danger] = 'Micropost not found'
    end
  end
end
