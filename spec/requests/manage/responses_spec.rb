# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage::Responses" do
  let(:manager) { create(:user, role: "Manager") }
  let(:regular_user) { create(:user, role: "User") }
  let!(:client) { create(:client) }
  let!(:mock_request) { create(:request, client: client) }

  describe "GET /manage/requests/:request_id/responses/new" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get new_manage_request_response_path(mock_request)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get new_manage_request_response_path(mock_request)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get new_manage_request_response_path(mock_request)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /manage/requests/:request_id/responses" do
    let(:valid_params) do
      {
        response: {
          name: "Success Response",
          status: 200,
          format: "JSON",
          throttle: 0,
          body: '{"message": "ok"}',
        },
      }
    end
    let(:invalid_params) { { response: { name: "", status: nil, format: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "creates a response with valid params" do
        expect do
          post manage_request_responses_path(mock_request), params: valid_params
        end.to change(Response, :count).by(1)
      end

      it "associates the response with the request" do
        post manage_request_responses_path(mock_request), params: valid_params
        expect(Response.last.request).to eq(mock_request)
      end

      it "redirects to root with HTML format" do
        post manage_request_responses_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        post manage_request_responses_path(mock_request), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not create a response with invalid params" do
        expect do
          post manage_request_responses_path(mock_request), params: invalid_params
        end.not_to change(Response, :count)
      end

      it "returns unprocessable content with invalid params" do
        post manage_request_responses_path(mock_request), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        post manage_request_responses_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not create a response" do
        expect do
          post manage_request_responses_path(mock_request), params: valid_params
        end.not_to change(Response, :count)
      end
    end
  end

  describe "GET /manage/responses/:id/edit" do
    let!(:mock_response) { create(:response, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get edit_manage_response_path(mock_response)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get edit_manage_response_path(mock_response)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /manage/responses/:id" do
    let!(:mock_response) { create(:response, request: mock_request, name: "Original Name") }
    let(:valid_params) { { response: { name: "Updated Name" } } }
    let(:invalid_params) { { response: { name: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "updates the response with valid params" do
        patch manage_response_path(mock_response), params: valid_params
        expect(mock_response.reload.name).to eq("Updated Name")
      end

      it "redirects to root with HTML format" do
        patch manage_response_path(mock_response), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        patch manage_response_path(mock_response), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not update response with invalid params" do
        patch manage_response_path(mock_response), params: invalid_params
        expect(mock_response.reload.name).to eq("Original Name")
      end

      it "returns unprocessable content with invalid params" do
        patch manage_response_path(mock_response), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        patch manage_response_path(mock_response), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not update the response" do
        patch manage_response_path(mock_response), params: valid_params
        expect(mock_response.reload.name).to eq("Original Name")
      end
    end
  end

  describe "GET /manage/responses/:id/delete" do
    let!(:mock_response) { create(:response, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get delete_manage_response_path(mock_response)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get delete_manage_response_path(mock_response)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /manage/responses/:id" do
    let!(:mock_response) { create(:response, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "destroys the response" do
        expect { delete manage_response_path(mock_response) }.to change(Response, :count).by(-1)
      end

      it "redirects to root with HTML format" do
        delete manage_response_path(mock_response)
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        delete manage_response_path(mock_response), as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        delete manage_response_path(mock_response)
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the response" do
        expect { delete manage_response_path(mock_response) }.not_to change(Response, :count)
      end
    end
  end
end
