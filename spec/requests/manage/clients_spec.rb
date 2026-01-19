# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manage::Clients" do
  let(:manager) { create(:user, role: "Manager") }
  let(:regular_user) { create(:user, role: "User") }

  describe "GET /manage/clients" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get manage_clients_path
        expect(response).to have_http_status(:success)
      end

      it "displays the clients list" do
        client = create(:client, name: "Test Client")
        get manage_clients_path
        expect(response.body).to include("Test Client")
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get manage_clients_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get manage_clients_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /manage/clients/new" do
    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get new_manage_client_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get new_manage_client_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is not logged in" do
      it "redirects to login" do
        get new_manage_client_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /manage/clients" do
    let(:valid_params) { { client: { name: "Test Client", slug: "test-client", description: "A test client" } } }
    let(:invalid_params) { { client: { name: "", slug: "", description: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "creates a client with valid params" do
        expect { post manage_clients_path, params: valid_params }.to change(Client, :count).by(1)
      end

      it "redirects to root with HTML format" do
        post manage_clients_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        post manage_clients_path, params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not create a client with invalid params" do
        expect { post manage_clients_path, params: invalid_params }.not_to change(Client, :count)
      end

      it "returns unprocessable content with invalid params" do
        post manage_clients_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        post manage_clients_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not create a client" do
        expect { post manage_clients_path, params: valid_params }.not_to change(Client, :count)
      end
    end
  end

  describe "GET /manage/clients/:id/edit" do
    let!(:client) { create(:client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get edit_manage_client_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get edit_manage_client_path(client)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /manage/clients/:id" do
    let!(:client) { create(:client, name: "Original Name") }
    let(:valid_params) { { client: { name: "Updated Name" } } }
    let(:invalid_params) { { client: { name: "" } } }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "updates the client with valid params" do
        patch manage_client_path(client), params: valid_params
        expect(client.reload.name).to eq("Updated Name")
      end

      it "redirects to root with HTML format" do
        patch manage_client_path(client), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        patch manage_client_path(client), params: valid_params, as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "does not update client with invalid params" do
        patch manage_client_path(client), params: invalid_params
        expect(client.reload.name).to eq("Original Name")
      end

      it "returns unprocessable content with invalid params" do
        patch manage_client_path(client), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        patch manage_client_path(client), params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "does not update the client" do
        patch manage_client_path(client), params: valid_params
        expect(client.reload.name).to eq("Original Name")
      end
    end
  end

  describe "GET /manage/clients/:id/delete" do
    let!(:client) { create(:client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "returns success" do
        get delete_manage_client_path(client)
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        get delete_manage_client_path(client)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /manage/clients/:id" do
    let!(:client) { create(:client) }

    context "when user is a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(manager) }

      it "destroys the client" do
        expect { delete manage_client_path(client) }.to change(Client, :count).by(-1)
      end

      it "redirects to root with HTML format" do
        delete manage_client_path(client)
        expect(response).to redirect_to(root_path)
      end

      it "returns turbo stream with turbo format" do
        delete manage_client_path(client), as: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when user is not a manager" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "redirects to root" do
        delete manage_client_path(client)
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the client" do
        expect { delete manage_client_path(client) }.not_to change(Client, :count)
      end
    end
  end
end
