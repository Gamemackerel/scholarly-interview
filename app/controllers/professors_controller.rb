# app/controllers/professors_controller.rb
class ProfessorsController < ApplicationController
  def index
    @professors = Professor.all
  end

  def show
    @professor = Professor.find(params[:id])
  end

  def fetch_projects
    @professor = Professor.find(params[:id])
    @professor.fetch_projects

    respond_to do |format|
      format.html { redirect_to @professor, notice: 'Projects are being fetched. Please refresh the page in a few moments.' }
      format.turbo_stream
    end
  end

  def refresh_projects
    @professor = Professor.find(params[:id])
    @projects = @professor.projects.reload

    respond_to do |format|
      format.html { redirect_to @professor }
      format.turbo_stream
    end
  end
end