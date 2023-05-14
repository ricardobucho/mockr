# frozen_string_literal: true

class RequestsController < ApplicationController
  def show
    @request = request_record

    @logs =
      Panko::ArraySerializer.new(
        log_records,
        each_serializer: Requests::LogSerializer,
      ).to_a

    render "_show"
  end

  private

  def request_record
    @request_record ||= Request.find(params[:id])
  end

  def log_records
    @log_records ||= request_record.logs.order(created_at: :desc).limit(25)
  end
end
