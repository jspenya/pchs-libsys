class Students::CommentsController < CommentsController
  before_action :authenticate_user!
  before_action :set_commentable

  private
  
  def set_commentable
    @commentable = Student.find(params[:student_id])
  end
end
