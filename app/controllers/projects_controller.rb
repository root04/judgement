class ProjectsController < ApplicationController
  before_action :require_belonging_organization
  before_action :detect_project, only: [:show]
  before_action :detect_aggregation_term, only: [:show]
  before_action :aggregation_term_data, only: [:show]

  def new
    @project = Project.new
  end

  def show
    @costs = @project.actual.costs.term_cost(@startday, @endday).order('order_date')

    unless current_user.member_of?(@project)
      raise Oniwa::Forbidden
    end
  end

  def create
    @project = current_user.create_project(
      params.require(:project).permit(:name).merge(organization: @organization)
    )

    if @project.persisted?
      redirect_to organization_project_path(@organization, @project)
    else
      @errors = @project.errors
      render :new
    end
  end

  private

  def require_belonging_organization
    @organization = current_user.organizations.find(params[:organization_id])
  end

  def detect_project
    @project = @organization.projects.find(params[:id])
  end

  def detect_aggregation_term
    if params[:endday]
      @endday = Time.parse(params[:endday])
    else
      @endday = Time.zone.today
    end

    if params[:startday]
      @startday = Time.parse(params[:startday])
    else
      @startday = @endday - 30
    end

    if @startday > @endday
      @startday = @endday
    end
      @startday = @startday.to_date
      @endday   = @endday.to_date
  end

  def aggregation_term_data
    @costs_term = {}
    @term_month = (@startday..@endday).select {|d| d.day == 1}
    @term_month.each do |month|
      cost = @project.actual.costs.term_cost(month, month.end_of_month).pluck(:cost).sum()
      @costs_term[month.to_s] = cost
    end
    gon.costs = @costs_term.to_json
  end
end
