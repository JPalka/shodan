# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    login { 'test_login' }
    password { Faker::Alphanumeric.alphanumeric(number: 8, min_numeric: 1) }
    master_server
    premium_points { nil }
    email { Faker::Internet.email }
  end
end
