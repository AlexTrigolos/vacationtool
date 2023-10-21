# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "#{i}@mail.ru" }
    sequence(:password) { 123_456 }

    factory :admin do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
