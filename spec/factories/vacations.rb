# frozen_string_literal: true

FactoryBot.define do
  factory :vacation do
    start_date { '2031-08-22' }
    end_date { '2031-08-23' }
    status { :created }
    user
  end
end
