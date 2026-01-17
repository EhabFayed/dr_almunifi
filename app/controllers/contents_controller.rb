class ContentsController < ApplicationController
  # GET /blog/:blog_id/contents
  def index
    blog = Blog.find(params[:blog_id])
    contents = blog.contents.where(is_deleted: false).order(:id).map do |content|
      {
        id: content.id,
        content_ar: content.content_ar,
        content_en: content.content_en,
        photos: content.content_photos.map do |cp|
          {
            cp_id: cp.id,
            url: cp.photo.attached? ? url_for(cp.photo) : nil,
            alt_ar: cp.alt_ar,
            alt_en: cp.alt_en
          }
        end
      }
    end
    render json: contents
  end

  # POST /blog/:blog_id/contents
  def create
    blog = Blog.find(params[:blog_id])
    content = blog.contents.build(content_params)
    content.user_id = current_user.id
    if content.save
      render json: {message: 'Content created successfully'}, status: :created
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blog/:blog_id/contents/:id
  def update
    content = Content.find(params[:id])
    if content.update(content_params)
      render json: {message: 'Content updated successfully'}, status: :ok
    else
      render json: { error: content.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /blog/:blog_id/contents/:id
  def destroy
    content = Content.find(params[:id])
      content.destroy
      render json: { message: 'Content deleted successfully' }, status: :ok
  end

  private
  def content_params
  params.require(:content).permit(
    :content_ar,
    :content_en,
    :blog_id,
    :user_id,
    :is_published,
    content_photos_attributes: [
      :id,
      :alt_ar,
      :alt_en,
      :photo,
      :_destroy
    ]
  )
  end

end