class PostsController < ApplicationController

  def index
    @posts = Post.all
    if request.xhr? || request.format == :json
      render json: @posts.as_json(only: [:id, :title, :body, :slug, :updated_at], methods: [:excerpt])
    else
      render
    end
  end

  def show
    @post = Post.find params[:id]
    if request.xhr?
      render json: @post.as_json(only: [:id, :title, :body, :slug, :updated_at], methods: [:excerpt])
    else
      render
    end
  end

end
