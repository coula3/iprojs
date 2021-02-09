require 'rack-flash'

class ProjectsController < ApplicationController
  use Rack::Flash  

  get "/projects" do
    if logged_in? && current_user.projects.empty?
      redirect "/about"
    elsif current_user
      @projects = current_user.projects.reverse
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
      project.update(phase: "Completed") if !params[:actual_end_date].blank?
      redirect "/projects"
    else
      flash[:message] = project.errors.full_messages.join(" ")
      redirect :"/projects/new"
    end
  end

  get "/projects/:slug" do
    if logged_in?
      if @project = current_user.projects.find_by_slug(params[:slug])
        @updated_at = localize_time(@project.updated_at)
        erb :"/projects/show.html"
      else
        flash[:message] = "You are only authorized to access your own projects"
        if !current_user.projects.empty?
          redirect "/projects"
        else
          redirect "/users/#{current_user.id}"
        end
      end
    else
      redirect "/signin"
    end
  end

  get "/projects/:slug/edit" do
    if logged_in?
      if @project = current_user.projects.find_by_slug(params[:slug])
        @list_classification = ["CLI", "Multi Page App", "Native Mobile App", "Progressive Web App", "Single Page App"].delete_if {|c| c == @project.classification}
        @list_project_type = ["Colloboration", "Individual"].delete_if {|n| n == @project.project_type}
        @list_phases = ["Planning", "Development", "Testing", "Completed", "Production"].sort.delete_if {|phase| phase == @project.phase}
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

    assign_new_params(new_params)

    original_old_object = old_object.dup

    if old_object.update(new_params)
      check_complimentary_updates(old_object, original_old_object)
      redirect "/projects/#{old_object.slug}"
    else
      flash[:message] = old_object.errors.full_messages.join(" ")
      redirect "/projects/#{params[:slug]}/edit"
    end
  end

  def assign_new_params(new_params)
    new_params["title"] = params[:title]
    new_params["domain"] = params[:domain]
    new_params["classification"] = params[:classification]
    new_params["project_type"] = params[:project_type]
    new_params["languages"] = params[:languages]
    new_params["libraries"] = params[:libraries]
    new_params["phase"] = params[:phase]
    new_params["start_date"] = params[:start_date]
    new_params["planned_end_date"] = params[:planned_end_date]
    new_params["actual_end_date"] = params[:actual_end_date]
    new_params["url"] = params[:url]
    new_params["notes"] = params[:notes]

    new_params
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

  helpers do
    def check_complimentary_updates(object, original_old_object)
      if !original_old_object.actual_end_date && params[:actual_end_date] && (original_old_object.phase != "Completed" || original_old_object.phase != "Production") && (object.phase != "Completed" || object.phase != "Production")
        object.update(phase: params[:phase]) if object.actual_end_date
      elsif original_old_object.actual_end_date && (object.phase != "Completed") && (params[:phase] != "Production")
        object.update(actual_end_date: nil) if params[:actual_end_date].present?
      end
    end
  end
end
