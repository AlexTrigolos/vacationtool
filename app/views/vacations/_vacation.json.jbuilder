# frozen_string_literal: true

json.extract! vacation, :id, :start_date, :end_date, :created_at, :updated_at
json.url vacation_url(vacation, format: :json)
