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
    user = User.new(params)
    user.save
    session[:id] = user.id
    erb :"/intro.html"
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
      unless current_user.projects.empty?
        redirect "/projects"
      else
        @user = current_user.first_name
        erb :"/intro.html"
      end
    end
  end

  get "/intro" do
    if current_user
      redirect "/projects"
    else
      erb :"/intro.html"
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
        @user = User.find_by(id: params[:id].to_i)
        erb :"/users/show.html"
      else
        redirect "/users/#{current_user.id}"
      end
    else
      redirect "/signin"
    end
  end

  get "/users/:id/edit" do
    @user = User.find_by(id: params[:id])
    @other_gender = ["Male", "Female", "Non-Binary"].delete_if {|gender| gender == current_user.gender}
    erb :"/users/edit.html"
  end

  patch "/users/:id" do
    id = params[:id]
    new_params = Hash.new
    old_object = User.find(id)
    # old_object.changed?
    
    new_params["first_name"] = params[:first_name]
    new_params["last_name"] = params[:last_name]
    new_params["organization"] = params[:organization]
    new_params["dob"] = params[:dob]
    new_params["gender"] = params[:gender]
    new_params["email"] = params[:email]
    
    old_object.first_name = new_params["first_name"]
    old_object.last_name = new_params["last_name"]
    old_object.organization = new_params["organization"]
    old_object.dob = new_params["dob"]
    old_object.gender = new_params["gender"]
    old_object.email = new_params["email"]
    # binding.pry
    # old_object.update(new_params) # updates all fields and returns error msg for password
    
    if old_object.valid?
      old_object.save
      flash[:message] = "Your profile has been successfully updated"
      redirect "/users/#{current_user.id}"
    else
      flash[:message] = "Update unsuccessful: #{old_object.errors.full_messages}"
      redirect "/users/#{current_user.id}/edit"
    end
  end
end
