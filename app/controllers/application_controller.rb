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
    if current_user && current_user.projects.empty?
      redirect :"/about"
    elsif logged_in?
      @last_project_created = current_user.projects.sort_by {|p| p.created_at if p.created_at}.last
      @last_project_updated = current_user.projects.sort_by {|p| p.updated_at if p.updated_at}.last
      @rate_of_timely_completion = get_rate_of_timely_completion

      erb :"/dashboard.html"
    else
      redirect :"/signin"
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @user ||= User.find_by(id: session[:id]) if session[:id]
    end

    def get_rate_of_timely_completion
      completed_projects = User.first.projects.select {|p| p.phase == "Completed" || p.phase == "Production"}
      on_time_completion = completed_projects.select {|p| p.planned_end_date >= p.actual_end_date}
      ((on_time_completion.size / completed_projects.size.to_f) * 100).round(1)
    end
  end
end
