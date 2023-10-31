# frozen_string_literal: true

json.extract! log, :id, :log_type, :milk_amount, :stool_little, :stool_color, :body_temperature, :description,
              :date_time, :created_at, :updated_at
json.url log_url(log, format: :json)
