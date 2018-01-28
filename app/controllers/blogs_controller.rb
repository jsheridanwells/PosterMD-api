class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :update, :destroy]
  
  def index
    @blogs = current_user.blogs
    json_response(@blogs)
  end

  def show
    json_response(@blog)
  end

  def create
    new_blog = current_user.blogs.create!(blog_params)
    json_response(new_blog, :created)
  end

  def update
    @blog.update(blog_params)
    json_response(@blog)
  end

  def destroy
    @blog.destroy
    head :no_content
  end

  private

    def blog_params
      params.permit(:title, :description)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    end

end