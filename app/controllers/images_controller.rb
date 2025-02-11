class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: %i[ show edit update destroy ]

  # GET /images or /images.json
  def index
    images = current_user.images
                          .by_tag_name(params[:tags])
                          .query(params[:query])
                          .order(created_at: :desc)
                          .includes(:tags)

    @tags = images.tags_with_count(with_total: true)
    @pagy, @images = pagy(images)
  end

  # GET /images/1 or /images/1.json
  def show
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
    @image = current_user.images.new(image_params)

    respond_to do |format|
      if @image.save
        format.html do
          redirect_to @image, notice: "Image was successfully created."
        end
      else
        format.html do
          flash[:alert] = @image.errors.full_messages
          redirect_back fallback_location: root_path
        end
      end
    end
  end

  # PATCH/PUT /images/1 or /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = current_user.images.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:name, :file, :description)
    end
end
