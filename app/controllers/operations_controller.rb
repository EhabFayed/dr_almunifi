class OperationsController < ApplicationController
 # GET /operations
  def index
    operations = Operation.not_deleted.order(:id).map do |operation|
      {
        id: operation.id,
        title_ar: operation.title_ar,
        title_en: operation.title_en,
        description_ar: operation.description_ar,
        description_en: operation.description_en,
        category: operation.category,
        slug: operation.slug,
        slug_ar: operation.slug_ar,
        photo_url: operation.photo.attached? ? url_for(operation.photo) : nil,
        meta_description_ar: operation.meta_description_ar,
        meta_description_en:  operation.meta_description_en,
        image_alt_text_ar: operation.image_alt_text_ar,
        image_alt_text_en: operation.image_alt_text_en,
        meta_title_ar: operation.meta_title_ar,
        meta_title_en: operation.meta_title_en,
        is_published: operation.is_published
      }
    end

    render json: operations
  end
  # POST /operations
  def create
    operation = Operation.create(operation_params)
    if operation.save
      render json: {message: "Operation created successfully"}
    else
      render json: { errors: operation.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # PUT /operations/:id
  def update
    operation = Operation.find(params[:id])
    if operation.update(operation_params)
      render json: {message: "Operation updated successfully"}
    else
      render json: { errors: operation.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /operations/:id
  def destroy
    operation = Operation.find(params[:id])
    operation.destroy
    render json: {message: "Operation deleted successfully"}, status: :ok
  end

  private
  def operation_params
    params.require(:operation).permit(
      :title_ar,
      :title_en,
      :image_alt_text_ar,
      :image_alt_text_en,
      :description_ar,
      :description_en,
      :meta_title_ar,
      :meta_title_en,
      :slug,
      :meta_description_ar,
      :meta_description_en,
      :category,
      :is_published,
      :photo,
      :slug_ar
    )
  end
end
