require 'rack-flash'

class ProjectsController < ApplicationController
  use Rack::Flash  

  get "/projects" do
    if current_user
      @projects = current_user.projects
      erb :"/projects/index.html"
    else
      redirect "/signin"
    end
  end

  get "/projects/new" do
    if current_user
      erb :"/projects/new.html"
    else
      redirect "/signin"
    end
  end

  post "/projects" do
    project = current_user.projects.build(params)
    if project.save
      redirect "/projects"
    else
      redirect :"/projects/new"
    end
  end

  get "/projects/:slug" do
    if logged_in?
      if @project = current_user.projects.find_by_slug(params[:slug])
        erb :"/projects/show.html"
      else
        flash[:message] = "You are not authorized to access /projects/#{params[:slug]}"
        redirect "/projects"
      end
    else
      redirect "/signin"
    end
  end

  get "/projects/:slug/edit" do
    if logged_in?
      if @project = current_user.projects.find_by_slug(params[:slug])
        @other_class = ["CLI", "Web Based"].delete_if {|c| c == @project.classification}
        @other_nature = ["Colloboration", "Individual"].delete_if {|n| n == @project.nature}
        @other_phases = ["Planning", "Development", "Testing", "Completed", "Production"].sort.delete_if {|phase| phase == @project.phase}
        erb :"/projects/edit.html"
      else
        redirect "/projects"
      end
    else
      redirect "/signin"
    end
  end

  patch "/projects/:slug" do
    new_params = Hash.new
    old_object = current_user.projects.find_by_slug(params[:slug])
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
    new_params["url"] = params[:url]
    new_params["notes"] = params[:notes]
    
    if old_object.update(new_params)
      redirect "/projects/#{old_object.slug}"
    else
      redirect "/projects/#{old_object.slug}/edit"
    end
  end

  delete "/projects/:id/delete" do
    project = current_user.projects.find_by(id: params[:id])
    project.destroy
    if current_user.projects.empty?
      redirect "/projects/new"
    else      
      redirect "/projects"
    end
  end
end
