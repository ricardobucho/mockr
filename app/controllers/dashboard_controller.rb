class DashboardController < ApplicationController
  helper_method :method_class_map

  def index; end

  def clients
    @clients =
      Client.
        includes(requests: :responses).
        references(requests: :responses).
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
        clients.name LIKE :query
        OR requests.name LIKE :query
        OR requests.path LIKE :query
        OR responses.name LIKE :query
        OR responses.conditions::text LIKE :query
      SQL
      query: "%#{query}%",
    )
  end
end
