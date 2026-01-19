# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage::Requests" do
  let(:manager) { create(:user, role: "Manager") }
  let(:regular_user) { create(:user, role: "User") }
  let!(:client) { create(:client) }

  describe "GET /manage/clients/:client_id/requests/new" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get new_manage_client_request_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get new_manage_client_request_path(client)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get new_manage_client_request_path(client)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /manage/clients/:client_id/requests" do
    let(:valid_params) do
      { request: { name: "Get Users", description: "Fetch all users", method: "GET", path: "users" } }
    end
    let(:invalid_params) { { request: { name: "", description: "", method: "", path: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "creates a request with valid params" do
        expect { post manage_client_requests_path(client), params: valid_params }.to change(Request, :count).by(1)
      end

      it "associates the request with the client" do
        post manage_client_requests_path(client), params: valid_params
        expect(Request.last.client).to eq(client)
      end

      it "redirects to root with HTML format" do
        post manage_client_requests_path(client), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        post manage_client_requests_path(client), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not create a request with invalid params" do
        expect { post manage_client_requests_path(client), params: invalid_params }.not_to change(Request, :count)
      end

      it "returns unprocessable content with invalid params" do
        post manage_client_requests_path(client), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        post manage_client_requests_path(client), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not create a request" do
        expect { post manage_client_requests_path(client), params: valid_params }.not_to change(Request, :count)
      end
    end
  end

  describe "GET /manage/requests/:id/edit" do
    let!(:mock_request) { create(:request, client: client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get edit_manage_request_path(mock_request)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get edit_manage_request_path(mock_request)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /manage/requests/:id" do
    let!(:mock_request) { create(:request, client: client, name: "Original Name") }
    let(:valid_params) { { request: { name: "Updated Name" } } }
    let(:invalid_params) { { request: { name: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "updates the request with valid params" do
        patch manage_request_path(mock_request), params: valid_params
        expect(mock_request.reload.name).to eq("Updated Name")
      end

      it "redirects to root with HTML format" do
        patch manage_request_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        patch manage_request_path(mock_request), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not update request with invalid params" do
        patch manage_request_path(mock_request), params: invalid_params
        expect(mock_request.reload.name).to eq("Original Name")
      end

      it "returns unprocessable content with invalid params" do
        patch manage_request_path(mock_request), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        patch manage_request_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not update the request" do
        patch manage_request_path(mock_request), params: valid_params
        expect(mock_request.reload.name).to eq("Original Name")
      end
    end
  end

  describe "GET /manage/requests/:id/delete" do
    let!(:mock_request) { create(:request, client: client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get delete_manage_request_path(mock_request)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get delete_manage_request_path(mock_request)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /manage/requests/:id" do
    let!(:mock_request) { create(:request, client: client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "destroys the request" do
        expect { delete manage_request_path(mock_request) }.to change(Request, :count).by(-1)
      end

      it "redirects to root with HTML format" do
        delete manage_request_path(mock_request)
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        delete manage_request_path(mock_request), as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        delete manage_request_path(mock_request)
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the request" do
        expect { delete manage_request_path(mock_request) }.not_to change(Request, :count)
      end
    end
  end
end
