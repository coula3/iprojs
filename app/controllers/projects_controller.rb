class ProjectsController < ApplicationController

  
  get "/projects" do
    if current_user
      @projects = current_user.projects
      erb :"/projects/index.html"
    else
      erb :"/users/signin.html"
    end
  end

  get "/projects/new" do
    erb :"/projects/new.html"
  end

  post "/projects" do
    project = current_user.projects.build(params)
    project.save
  
    redirect "/projects"
  end

  get "/projects/:slug" do
    @project = Project.find_by_slug(params[:slug])
    erb :"/projects/show.html"
  end

  get "/projects/:slug/edit" do
    # binding.pry
    @project = Project.find_by_slug(params[:slug])
    erb :"/projects/edit.html"
  end

  patch "/projects/:slug" do
    # binding.pry
    new_params = Hash.new
    old_object = Project.find_by_slug(params[:slug])
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
    
    if old_object.update(new_params)
      redirect "/projects/#{old_object.slug}"
    else
      redirect "/projects/#{old_object.slug}/edit"
    end

  end

  delete "/projects/:id/delete" do
    project = Project.find_by(id: params[:id])
    # binding.pry
    project.destroy
    redirect "/projects"
  end
end
