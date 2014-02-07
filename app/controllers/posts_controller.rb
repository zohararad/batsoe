class PostsController < ApplicationController

  def index
    @posts = Post.all
    if request.xhr?
      render json: @posts.to_json
    else
      render
    end
  end

  def show
    @post = Post.find params[:id]
    if request.xhr?
      render json: @post.to_json
    else
      render
    end
  end

end
