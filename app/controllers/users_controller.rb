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

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
