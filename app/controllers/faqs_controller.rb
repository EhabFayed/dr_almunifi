class FaqsController < ApplicationController


  # GET /blog/:blog_id/faqs
  def index
    blog = Blog.find(params[:blog_id])
    faqs = blog.faqs.where(is_deleted: false).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end

  # POST /blog/:blog_id/faqs
  def create
    blog = Blog.find(params[:blog_id])

    faq = blog.faqs.build(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: {message: 'Faq created successfully'}, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /faqs
  # This action allows creating a FAQ without a blog reference
  def create_without_blog
    faq = Faq.new(faq_params)
    faq.user_id = current_user.id
    if faq.save
      render json: {message: 'Faq created successfully'}, status: :created
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # GET /faqs
  def index_without_blog
    faqs = Faq.where(is_deleted: false, blog_id: nil).order(:id).map do |faq|
      {
        id: faq.id,
        question_ar: faq.question_ar,
        question_en: faq.question_en,
        answer_ar: faq.answer_ar,
        answer_en: faq.answer_en,
        is_published: faq.is_published
      }
    end
    render json: faqs
  end
  # PATCH/PUT /faqs/:id
  def update_without_blog
    faq = Faq.find(params[:id])
    if faq.update(faq_params)
      render json: {message: 'Faq updated successfully'}, status: :ok
    else
      render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # DELETE /faqs/:id
  def delete_without_blog
    faq = Faq.find(params[:id])
    faq.update(is_deleted: true)
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end
  # PATCH/PUT blog/:blog_id/faqs/:id
  def update
    faq = Faq.find(params[:id])
      if faq.update(faq_params)
        render json: {message: 'Faq updated successfully'}, status: :ok
      else
        render json: { error: faq.errors.full_messages }, status: :unprocessable_entity
      end
  end

  # DELETE blog/:blog_id/faqs/:id
  def destroy
    faq = Faq.find(params[:id])
    faq.destroy
    render json: { message: 'Faq deleted successfully' }, status: :ok
  end

  private

  def faq_params
    params.require(:faq).permit(:question_ar, :question_en, :answer_ar, :answer_en, :is_published)
  end
end
