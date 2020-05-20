require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash
  
  get "/signup" do
    if current_user
      redirect "/projects"
    else
      erb :"/users/signup.html"
    end
  end
  
  post "/signup" do
    user = User.new(first_name: params[:first_name].capitalize, last_name: params[:last_name].capitalize, organization: params[:organization].titlecase, date_of_birth: params[:date_of_birth], gender: params[:gender], email: params[:email].downcase, password: params[:password])

    if user.save
      session[:id] = user.id
      @user = current_user.first_name
      erb :"/about.html"
    else
      flash[:message] = "Sign up unsuccessful: #{user.errors.full_messages.join(", ")}"
      redirect "/signup"
    end
  end
  
  get "/signin" do
    if current_user
      redirect "/projects"
    else
      erb :"/users/signin.html"
    end
  end

  post "/signin" do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      flash[:message].clear if flash[:message]
      unless current_user.projects.empty?
        redirect "/projects"
      else
        erb :"/about.html"
      end
    else
      flash[:message] = "Invalid email or password"
      erb :"/users/signin.html"
    end
  end

  get "/signout" do
    if !logged_in?
      redirect "/signin"
    else
      @first_name = current_user.first_name
      session.clear
      erb :"/users/bye.html"
    end
  end

  get "/users/:id" do
    if logged_in?
      if current_user.id == params[:id].to_i
        @user = User.find_by(id: params[:id])
        erb :"/users/show.html"
      else
        redirect "/users/#{current_user.id}"
      end
    else
      redirect "/signin"
    end
  end
  
  get "/users/:id/edit" do
    if logged_in?
      if current_user.id == params[:id].to_i
        @user = User.find_by(id: params[:id])
        erb :"/users/edit.html"
      else
        redirect "/users/#{current_user.id}"
      end
    else
      redirect "/signin"
    end
  end
  
  patch "/users/:id" do
    id = params[:id]
    new_params = Hash.new
    old_object = User.find(id)
    
    old_object.first_name = params["first_name"].capitalize
    old_object.last_name = params["last_name"].capitalize
    old_object.organization = params["organization"].titlecase
    old_object.date_of_birth = params["date_of_birth"]
    old_object.gender = params["gender"]
    old_object.email = params["email"].downcase
    old_object.password = params["password"]
    
    if old_object.valid?
      old_object.save
      flash[:message] = "Your profile has been successfully updated"
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "Update unsuccessful: #{old_object.errors.full_messages.join(", ")}"
      redirect "/users/#{current_user.id}/edit"
    end
  end
end