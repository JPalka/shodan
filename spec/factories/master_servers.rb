# frozen_string_literal: true

FactoryBot.define do
  factory :master_server do
    link { Faker::Internet.url(scheme: 'https') }
  end
end
