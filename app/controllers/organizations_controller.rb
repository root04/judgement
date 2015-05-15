class OrganizationsController < ApplicationController
  before_action :require_contact_input, only: [:contact]

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.create_organization(
      params.require(:organization).permit(:name)[:name]
    )

    if @organization.persisted?
      redirect_to dashboard_organization_path(@organization)
    else
      @errors = @organization.errors.full_messages
      render :new
    end
  end

  def show
    @organization = Organization.find(params[:id])
    @organizations = current_user.organizations
  end

  def dashboard
    @organization = current_user.organizations.no(params[:id]).first
    raise Cravitee::Forbidden unless @organization
  end

  def contact
    current_user.contact_to(@organization, @from_organization)
    flash[:message] = "Contact email successfully sent."

    redirect_to organization_path(@organization)
  end

  def search
    if params[:keyword].present?
      @organizations = Organization.where("name LIKE ?", "%#{params[:keyword]}%").page params[:page]
    else
      @organizations = Organization.page(params[:page])
    end

    respond_to do |format|
      format.html
      format.json { render json: @organizations }
    end
  end

  private

  def require_contact_input
    @organization = Organization.find(params[:id])
    @from_organization = current_user.organizations.find_by_id(params[:organization_id])
    unless @from_organization
      flash[:error] = "Select your organization to be introduced."
      redirect_to organization_path(@organization)
    end
  end
end
