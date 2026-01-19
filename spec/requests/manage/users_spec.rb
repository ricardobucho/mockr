# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage::Users" do
  let(:manager) { create(:user, role: "Manager") }
  let(:regular_user) { create(:user, role: "User") }

  describe "GET /manage/users" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get manage_users_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get manage_users_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get manage_users_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /manage/users/:id/edit" do
    let!(:target_user) { create(:user, role: "User") }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get edit_manage_user_path(target_user)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get edit_manage_user_path(target_user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /manage/users/:id" do
    let!(:target_user) { create(:user, role: "User") }
    let(:valid_params) { { user: { role: "Manager" } } }
    let(:invalid_params) { { user: { role: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "updates the user role with valid params" do
        patch manage_user_path(target_user), params: valid_params
        expect(target_user.reload.role).to eq("Manager")
      end

      it "redirects to manage users with HTML format" do
        patch manage_user_path(target_user), params: valid_params
        expect(response).to redirect_to(manage_users_path)
      end

      it "returns turbo stream with turbo format" do
        patch manage_user_path(target_user), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not update user with invalid params" do
        patch manage_user_path(target_user), params: invalid_params
        expect(target_user.reload.role).to eq("User")
      end

      it "returns unprocessable content with invalid params" do
        patch manage_user_path(target_user), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        patch manage_user_path(target_user), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not update the user" do
        patch manage_user_path(target_user), params: valid_params
        expect(target_user.reload.role).to eq("User")
      end
    end
  end
end
