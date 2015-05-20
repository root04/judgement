class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update_attributes(params.require(:user).permit(:name))
      redirect_to edit_user_path(current_user)
    else
      @errors = current_user.errors.full_messages
      render :edit
    end
  end
end
