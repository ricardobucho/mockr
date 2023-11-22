# frozen_string_literal: true

class DashboardController < ApplicationController
  helper_method :method_class_map

  def index; end

  def clients
    @clients =
      Client.
        includes(requests: %i[indices responses]).
        references(requests: %i[indices responses]).
        merge(clients_search_sql)

    render "dashboard/endpoints/_clients"
  end

  private

  def method_class_map
    @method_class_map ||= {
      "GET" => "success",
      "POST" => "info",
      "PUT" => "warning",
      "PATCH" => "warning",
      "DELETE" => "danger",
    }
  end

  def query
    params[:q] || nil
  end

  def clients_search_sql
    return Client.all if query.blank?

    Client.where(
      <<~SQL.squish,
        clients.name ilike :query
        or requests.name ilike :query
        or requests.path ilike :query
        or indices.name ilike :query
        or indices.path ilike :query
        or responses.name ilike :query
        or responses.conditions::text ilike :query
      SQL
      query: "%#{query.chars.join('%')}%",
    )
  end
end
