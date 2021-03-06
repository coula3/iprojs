require './config/environment'
require 'dotenv'
Dotenv.load('secrets.env')

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SECRET_KEY']
  end

  get "/" do
    if logged_in?
      redirect "/projects"
    else
      erb :"/welcome.html"
    end
  end

  get "/about" do
    erb :"/about.html"
  end

  get "/dashboard" do
    if current_user && current_user.projects.empty?
      redirect :"/about"
    elsif logged_in?
      @last_project_created = get_last_project_created
      @last_project_updated = get_last_project_updated
      @rate_of_timely_completion = get_rate_of_timely_completion
      erb :"/dashboard.html"
    else
      redirect :"/signin"
    end
  end

  get "/project_dates_analysis" do
    @current_user_projects = current_user.projects.where.not(actual_end_date: nil).reverse
    erb :"/projects/project_dates_analysis.html"
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @user ||= User.find_by(id: session[:id]) if session[:id]
    end

    def get_last_project_created
      current_user.projects.sort_by {|p| p.created_at if p.created_at}.last
    end

    def get_last_project_updated
      current_user.projects.sort_by {|p| p.updated_at if p.updated_at}.last
    end

    def get_rate_of_timely_completion
      completed_projects = current_user.projects.where(["phase = ? or phase = ?", "Completed", "Production"])
      on_time_completion = completed_projects.where("planned_end_date >= actual_end_date")
      ((on_time_completion.size / completed_projects.size.to_f) * 100).round(1)
    end

    def current_year
      Time.now.to_s.slice(0,4)
    end

    def localize_time(time)
      hour = 60 * 60
      time.dst? ? (diff_to_UTC = hour * 4) : (diff_to_utc = hour * 5)

      localize_time = time - diff_to_utc
    end
  end
end
