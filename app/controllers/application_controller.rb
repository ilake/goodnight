class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  def resource_not_found
    render json: { error_message: 'Record Not Found'  }, status: :not_found
  end

  private

  # XXX: Although there is not authentication flow, it is better to have current user concept.
  # Let all the behaviors(sleep records, follows) under this scope.
  def current_user
    @user = User.find(params[:user_id])
  end
end
