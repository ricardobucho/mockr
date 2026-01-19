# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage::Indices" do
  let(:manager) { create(:user, role: "Manager") }
  let(:regular_user) { create(:user, role: "User") }
  let!(:client) { create(:client) }
  let!(:mock_request) { create(:request, client: client) }

  describe "GET /manage/requests/:request_id/indices/new" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get new_manage_request_index_path(mock_request)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get new_manage_request_index_path(mock_request)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get new_manage_request_index_path(mock_request)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /manage/requests/:request_id/indices" do
    let(:valid_params) do
      {
        index: {
          name: "Users Index",
          description: "Paginated users list",
          method: "GET",
          path: "users",
          status: 200,
          throttle: 0,
          template: "<%= response.to_json %>",
        },
      }
    end
    let(:invalid_params) { { index: { name: "", method: "", path: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "creates an index with valid params" do
        expect { post manage_request_indices_path(mock_request), params: valid_params }.to change(Index, :count).by(1)
      end

      it "associates the index with the request" do
        post manage_request_indices_path(mock_request), params: valid_params
        expect(Index.last.request).to eq(mock_request)
      end

      it "redirects to root with HTML format" do
        post manage_request_indices_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        post manage_request_indices_path(mock_request), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not create an index with invalid params" do
        expect { post manage_request_indices_path(mock_request), params: invalid_params }.not_to change(Index, :count)
      end

      it "returns unprocessable content with invalid params" do
        post manage_request_indices_path(mock_request), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        post manage_request_indices_path(mock_request), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not create an index" do
        expect { post manage_request_indices_path(mock_request), params: valid_params }.not_to change(Index, :count)
      end
    end
  end

  describe "GET /manage/indices/:id/edit" do
    let!(:index) { create(:index, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get edit_manage_index_path(index)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get edit_manage_index_path(index)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /manage/indices/:id" do
    let!(:index) { create(:index, request: mock_request, name: "Original Name") }
    let(:valid_params) { { index: { name: "Updated Name" } } }
    let(:invalid_params) { { index: { name: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "updates the index with valid params" do
        patch manage_index_path(index), params: valid_params
        expect(index.reload.name).to eq("Updated Name")
      end

      it "redirects to root with HTML format" do
        patch manage_index_path(index), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        patch manage_index_path(index), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not update index with invalid params" do
        patch manage_index_path(index), params: invalid_params
        expect(index.reload.name).to eq("Original Name")
      end

      it "returns unprocessable content with invalid params" do
        patch manage_index_path(index), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        patch manage_index_path(index), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not update the index" do
        patch manage_index_path(index), params: valid_params
        expect(index.reload.name).to eq("Original Name")
      end
    end
  end

  describe "GET /manage/indices/:id/delete" do
    let!(:index) { create(:index, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get delete_manage_index_path(index)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get delete_manage_index_path(index)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /manage/indices/:id" do
    let!(:index) { create(:index, request: mock_request) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "destroys the index" do
        expect { delete manage_index_path(index) }.to change(Index, :count).by(-1)
      end

      it "redirects to root with HTML format" do
        delete manage_index_path(index)
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        delete manage_index_path(index), as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        delete manage_index_path(index)
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the index" do
        expect { delete manage_index_path(index) }.not_to change(Index, :count)
      end
    end
  end
end
