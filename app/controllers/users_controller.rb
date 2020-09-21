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
    if current_user
      redirect "/about"
    else
      user = User.new(first_name: params[:first_name].titlecase, last_name: params[:last_name].titlecase.sanitize_name_roman_suffix, organization: params[:organization].titlecase, date_of_birth: params[:date_of_birth], gender: params[:gender], email: params[:email].downcase, password: params[:password], password_confirmation: params[:password_confirmation])

      if user.save
        session[:id] = user.id
        erb :"/about.html"
      else
        flash[:message] = "#{user.errors.full_messages.uniq.join(", ")}"
        erb :"/users/signup.html"
      end
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
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      unless current_user.projects.empty?
        redirect "/projects"
      else
        erb :"/about.html"
      end
    elsif params[:email].blank? && params[:password].blank?
      flash[:message] = "A valid email and a password is required"
      erb :"/users/signin.html"
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

  get "/users/:slug" do
    if logged_in?
      if current_user == User.find_by_slug(params[:slug])
        @user = User.find_by_slug(params[:slug])
        erb :"/users/show.html"
      else
        redirect "/users/#{current_user.slug}"
      end
    else
      redirect "/signin"
    end
  end
  
  get "/users/:slug/edit" do
    if logged_in?
      if current_user == User.find_by_slug(params[:slug])
        @user = User.find_by_slug(id: params[:slug])
        @other_gender = ["Male", "Female", "Non-Binary"].delete_if {|gender| gender == current_user.gender}
        erb :"/users/edit.html"
      else
        redirect "/users/#{current_user.slug}"
      end
    else
      redirect "/signin"
    end
  end
  
  patch "/users/:slug" do
    new_params = Hash.new
    old_object = User.find_by_slug(params[:slug])
    
    old_object.first_name = params["first_name"].titlecase
    old_object.last_name = params["last_name"].titlecase.sanitize_name_roman_suffix
    old_object.organization = params["organization"].titlecase
    old_object.date_of_birth = params["date_of_birth"]
    old_object.gender = params["gender"]
    old_object.email = params["email"].downcase

    if old_object.changed?
      if old_object.save
        flash[:message] = "Your profile has been successfully changed"
        redirect "/users/#{current_user.slug}"
      else
        flash[:message] = "Update unsuccessful: #{old_object.errors.full_messages.join(", ")}"
        redirect "/users/#{current_user.slug}/edit"
      end
    else
      flash[:message] = "No change to your profile"
      redirect "/users/#{current_user.slug}"
    end
  end

  get "/users/:slug/change_password" do
    if logged_in?
      if current_user == User.find_by_slug(params[:slug])
        @user = User.find_by_slug(params[:slug])
        erb :"users/change_password.html"
      else
        redirect "/users/#{current_user.slug}"
      end
    else
      redirect "/signin"
    end
  end

  patch "/users/:slug/change_password" do
    user = User.find_by_slug(params[:slug])
    if params[:current_password].blank? || params[:new_password].blank?
      flash[:message] = "Please provide your current and new passwords to continue"
      redirect "/users/#{user.slug}/change_password"
    elsif !user.authenticate(params[:current_password])
      flash[:message] = "The current password provided does not match your records"
      redirect "/users/#{user.slug}/change_password"
    elsif user.update(password: params[:new_password], password_confirmation: params[:password_confirmation])
      flash[:message] = "Your password has been successfully changed"
      redirect "/users/#{user.slug}"
    else
      flash[:message] = "#{user.errors.full_messages.uniq.join(", ")}"
      redirect "/users/#{user.slug}/change_password"
    end
  end

  helpers do
    def calculate_age
      current_user.calculate_age
    end
  end
end