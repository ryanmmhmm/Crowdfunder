class ProjectsController < ApplicationController

	# load_before :load_user

	def index
		@projects = Project.all.order(start_date: :asc)
		@categories = ['Art','Comics', 'Crafts', 'Dance', 'Design', 'Fashion', 'Film & Video', 'Food', 'Games', 'Journalism', 'Music', 'Photography', 'Publishing', 'Technology', 'Theatre']

		@projects = if params[:title]
			Project.where("LOWER(title) LIKE LOWER (?)", "%#{params[:title]}%")
		else
			Project.all.order(start_date: :asc)
		end
	end

	def show
		@project = Project.find(params[:id])
	end

	def new
		@project = Project.new
	end

	def edit
		@project = Project.find(params[:id])
	end

	def create
		@project = Project.new(project_params)
		@user.owned_projects << @project

		if current_user && @project.save
			redirect_to projects_url
		else
			render :new
		end
	end

	def update
		@project = Project.find(params[:id])

		if @project.update_attributes(project_params)
			redirect_to projects_path(@project)
		else
			render :edit
		end
	end

	def destroy
		@project = Project.find(params[:id])
		@project.destroy
		redirect_to projects_path

	end

	private
	def project_params
		params.require(:project).permit(:title, :start_date, :end_date, :funding_goal, :description, rewards: [:amount, :description, :_destroy])
	end

	def load_user
		@user = current_user if current_user?
	end
end
