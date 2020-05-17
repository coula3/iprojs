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
    new_params = Hash.new
    old_object = Project.find(params[:id])
    # binding.pry
    new_params["title"] = params[:title]
    new_params["domain"] = params[:domain]
    new_params["classification"] = params[:classification]
    new_params["nature"] = params[:nature]
    new_params["languages"] = params[:languages]
    new_params["libraries"] = params[:libraries]
    new_params["phase"] = params[:phase]
    new_params["start_date"] = params[:start_date]
    new_params["planned_end_date"] = params[:planned_end_date]
    new_params["actual_end_date"] = params[:actual_end_date]
    new_params["notes"] = params[:notes]
    
    old_object.update(new_params)
    # binding.pry

    redirect "/projects/#{old_object.id}"
  end

  delete "/projects/:id/delete" do
    project = Project.find_by(id: params[:id])
    # binding.pry
    project.destroy
    redirect "/projects"
  end
end
