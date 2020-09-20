require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "iprojs_top_super_secret"
  end

  get "/" do
    if logged_in?
      redirect "/projects"
    else
      erb :welcome
    end
  end

  get "/about" do
    erb :"/about.html"
  end

  get "/dashboard" do
    erb :"/dashboard.html"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @user ||= User.find_by(id: session[:id]) if session[:id]
    end
  end
end
