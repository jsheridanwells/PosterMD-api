class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_blog

  def index
    json_response(@blog.posts)
  end

  def show
    json_response(@post)
  end

  def create
    @blog.posts.create!(post_params)
    json_response(@blog.posts.last, :created)
  end

  def update
    @post.update(post_params)
    json_response(@post)
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private
    def post_params
      params.permit(:title, :content, :published, :publish_date)
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def set_blog
      @blog = Blog.find(params[:blog_id])
    end

end