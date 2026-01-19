# frozen_string_literal: true

require "rails_helper"

RSpec.describe RequestLogger, type: :service do
  subject(:create_log_entry) do
    described_class.new(
      user,
      request,
      client_request,
      client_index,
      client_response,
    )
  end

  let(:user) { nil }
  let(:request) { nil }
  let(:client_request) { nil }
  let(:client_index) { nil }
  let(:client_response) { nil }

  context "when all the parameters are present" do
    let(:user) { create(:user) }
    let(:client_response) { create(:response) }
    let(:client_request) { client_response.request }
    let(:client) { client_request.client }
    let(:request) { build_mock_request(client, client_request) }

    it "creates a response log entry", :aggregate_failures do
      expect { create_log_entry.call }.to change(Log, :count).by(1)

      entry = create_log_entry.call
      expect(entry).to be_a(Log)
      expect(entry.request_id).to eq(client_request.id)
      expect(entry.data.deep_symbolize_keys).to match(
        expected_log_data(user, client, client_request, client_response),
      )
    end

    context "when the log is for an index" do
      let(:client_index) { create(:index, request: client_request, path: "index") }

      it "creates an index log entry", :aggregate_failures do
        expect { create_log_entry.call }.to change(Log, :count).by(1)

        entry = create_log_entry.call
        expect(entry).to be_a(Log)
        expect(entry.request_id).to eq(client_request.id)
        expect(entry.data.deep_symbolize_keys).to match(
          expected_index_log_data(user, client, client_request, client_index),
        )
      end
    end
  end

  private

  def build_mock_request(client, client_request)
    instance_double(
      ActionDispatch::Request,
      user_agent: "Fake User Agent",
      ip: "0.0.0.0",
      path: "/api/v1/clients/#{client.slug}#{client_request.path}",
      path_parameters: { client: client.name },
      query_parameters: { example: "value" },
      request_parameters: { example: "value" },
    )
  end

  def expected_log_data(user, client, client_request, client_response)
    {
      user: {
        id: user.id,
        provider: user.provider,
        uid: user.provider_uid,
        email: user.provider_email,
      },
      request: {
        name: client_request.name,
        client: client.name,
        path: "/api/v1/clients/#{client.slug}#{client_request.path}",
        query_params: { example: "value" },
        body_params: { example: "value" },
        user_agent: "Fake User Agent",
        ip: "0.0.0.0",
      },
      response: {
        id: client_response.id,
        name: client_response.name,
        status: client_response.status,
        throttle: client_response.throttle,
        headers: client_response.headers,
        conditions: client_response.conditions,
      },
    }
  end

  def expected_index_log_data(user, client, client_request, client_index)
    {
      user: {
        id: user.id,
        provider: user.provider,
        uid: user.provider_uid,
        email: user.provider_email,
      },
      request: {
        name: client_request.name,
        client: client.name,
        path: "/api/v1/clients/#{client.slug}#{client_request.path}",
        query_params: { example: "value" },
        body_params: { example: "value" },
        user_agent: "Fake User Agent",
        ip: "0.0.0.0",
      },
      response: {
        id: client_index.id,
        name: client_index.name,
        status: client_index.status,
        throttle: client_index.throttle,
        headers: client_index.headers,
        properties: client_index.properties,
      },
    }
  end
end
