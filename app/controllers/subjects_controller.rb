class SubjectsController < ApplicationController
  before_action :check_user

  def check_user
    @user = current_user
    if @user.admin?
    else
      flash[:notice] = "You have no power!" 
      redirect_to root_path
    end
  end

  def index
    @user = current_user
    @subjects = Subject.all
    if params[:keyword].present?
			@subjects = @subjects.where('lower(name) LIKE :query', query: "%#{(params[:keyword]).downcase}%")
		end
  end

  def new
    @user = current_user
    @subject = Subject.new
  end

  def create
    @user = current_user
    @subject = Subject.new(subject_params)
    
    if @subject.save
      flash[:notice] = "Subject category created!"
      redirect_to action: :index
    else
      flash[:error] = "Subject category creation failed ):"
      redirect_to action: :new
    end
  end

  def edit
    @user = current_user
    @subject = Subject.find(params[:id])
  end

  def update
    @subject = Subject.find(params[:id])

    if @subject.update(subject_params)
      flash[:notice] = "Successfully edited!"
      redirect_to action: :index
    else
      flash[:error] = "Edit failed ):"
      redirect_to action: :edit
    end
  end

  def delete
    Subject.find(params[:id]).destroy
    flash[:notice] = 'Subject deleted successfully'
    redirect_to action: :index
  end

  private
  def subject_params
    params.require(:subject).permit(:name)
  end
end