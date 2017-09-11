require 'grape'
require 'grape-swagger'
require 'tyrion'

# Create exception like objects for the logger
class DummyException
  attr_accessor :message, :backtrace
  def initialize(m, b)
    @message = m
    @backtrace = b
  end
end

module ErrorFormatter
  def self.call message, backtrace, options, env
    Tyrion::Config.instance.api_logger.exception("'error' response", DummyException.new(message, backtrace))
    { :response_type => 'error', :response => message, :backtrace => backtrace }.to_json
  end
end

module Tyrion
  class API < Grape::API
    format :json
    error_formatter :json, ErrorFormatter
    rescue_from :all

    helpers do
      def logger
        @logger ||= Tyrion::Config.instance.api_logger
      end
    end

    resource :users do
      desc 'User enters a new post'
      params do
        requires :content, type: String
      end
      route_param :id do
        post 'posts' do
          user = Tyrion::Models::User.find(params[:id])
          post = user.posts.create!(content: params[:content])
          { 'post_id' => post.id }
        end
      end

      desc 'User edits a post'
      params do
        requires :content, type: String
      end
      put '/:id/posts/:post_id' do
        user = Tyrion::Models::User.find(params[:id])
        post = user.posts.find(params[:post_id])
        post[:content] = params[:content]
        post.save!

        { 'post_id' => post.id }
      end

      desc 'Create a new user'
      params do
        requires :username, type: String
      end
      post do
        user = Tyrion::Models::User.create!(username: params[:username])

        { 'user_id' => user.id }
      end
    end

    resource :posts do
      desc 'Deletes a post'
      route_param :id do
        delete do
          post = Tyrion::Models::Post.find(params[:id])
          post.destroy

          { 'post_id' => post.id }
        end
      end

      desc 'Upvote for a post'
      params do
        requires :user_id, type: String
      end

      put ':post_id/upvote' do
        post = Tyrion::Models::Post.find(params[:post_id])
        post.upvote(params[:user_id])

        { 'post_id' => post.id }
      end

      desc 'Downvote for a post'
      params do
        requires :user_id, type: String
      end

      put ':post_id/downvote' do
        post = Tyrion::Models::Post.find(params[:post_id])
        post.downvote(params[:user_id])

        { 'post_id' => post.id }
      end

      desc 'Get the hottest posts'
      get 'hot_posts' do
        Tyrion::Models::Post.hot_posts
      end
    end

    resource :monitor do
      desc 'Make sure everthing is OK and return UP'
      get do
        'UP'
      end
    end

    add_swagger_documentation(hide_documentation_path: true)
  end
end
