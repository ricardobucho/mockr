# frozen_string_literal: true

module Manage
  class UsersController < BaseController
    before_action :set_user, only: %i[edit update]

    def index
      @users = User.order(:provider_username)
      authorize! User
    end

    def edit
      authorize! @user
    end

    def update
      authorize! @user

      if @user.update(user_params)
        @users = User.order(:provider_username)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              render_toast(resource_type: "User", resource_name: @user.provider_username, action: :updated),
              turbo_stream.update("drawer", partial: "manage/users/drawer_content", locals: { users: @users }),
            ]
          end
          format.html { redirect_to manage_users_path, notice: t("flash.manage.users.updated") }
        end
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:role)
    end
  end
end
