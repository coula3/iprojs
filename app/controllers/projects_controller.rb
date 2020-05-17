class ProjectsController < ApplicationController

  
  get "/projects" do
    @projects = current_user.projects
    erb :"/projects/index.html"
  end

  get "/projects/new" do
    erb :"/projects/new.html"
  end

  post "/projects" do
    project = current_user.projects.build(params)
    project.save
  
    redirect "/projects"
  end

  get "/projects/:id" do
    @project = Project.find_by(id: params[:id])
    # binding.pry
    erb :"/projects/show.html"
  end

  get "/projects/:id/edit" do
    @project = Project.find_by(id: params[:id])
    # binding.pry
    erb :"/projects/edit.html"
  end

  patch "/projects/:id" do
    redirect "/projects/:id"
  end

  delete "/projects/:id/delete" do
    project = Project.find_by(id: params[:id])
    # binding.pry
    project.destroy
    redirect "/projects"
  end
end
