class UsersController < ApplicationController

  
  get "/signup" do
    erb :"/users/signup.html"
  end
  
  post "/signup" do
    user = User.new(params)
    user.save
    session[:id] = user.id
    binding.pry
    redirect "/projects"
  end
  
  get "/signin" do
    erb :"/users/signin.html"
  end

  post "/signin" do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      # binding.pry
      redirect "/projects"
    end
  end

  get "/signout" do
    session.clear
    # binding.pry
    erb :"/users/bye.html"
  end

  get "/users/:id" do
    # binding.pry
    @user = User.find_by(id: params[:id])
    erb :"/users/show.html"
  end

  get "/users/:id/edit" do
    @user = User.find_by(id: params[:id])
    erb :"/users/edit.html"
  end

  patch "/users/:id" do
    id = params[:id]
    new_params = Hash.new
    old_object = User.find(id)
    new_params[:first_name] = params[:first_name]
    new_params[:last_name] = params[:last_name]
    new_params[:last_name] = params[:last_name]
    new_params[:organization] = params[:organization]
    new_params[:dob] = params[:dob]
    new_params[:gender] = params[:gender]
    new_params[:email] = params[:email]

    old_object.update(new_params)
    
    redirect "/users/#{current_user.id}"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
