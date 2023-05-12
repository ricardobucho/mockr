# frozen_string_literal: true

module Clients
  class AccountsController < ApplicationController
    def search
      accounts =
        client.accounts.where(
          "identifier ilike ?",
          "%#{query}%",
        ).map do |account|
          {
            identifier: account.identifier,
            classification: Account.classifications[account.classification],
          }
        end

      render json: accounts
    end

    def fetch
      account = client.accounts.find_by(
        identifier:,
        classification:,
      )

      if account.blank?
        return render(
          status: :not_found,
          json: {
            error: "Account not found!",
            identifier:,
            classification:,
          },
        )
      end

      render json: account.data
    end

    private

    def query
      @query ||= params[:query]
    end

    # rubocop:disable Security/Eval

    def identifier
      @identifier ||= eval(client.account_number_condition)
    end

    def classification
      @classification ||= eval(client.account_classification_condition)
    end

    # rubocop:enable Security/Eval

    def client
      @client ||= Client.find_by!(slug: client_slug)
    end

    def client_slug
      @client_slug ||= request.path_parameters[:client_slug]
    end
  end
end
