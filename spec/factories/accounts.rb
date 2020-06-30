FactoryBot.define do
  factory :account do
    login { "test_login" }
    password { Faker::Internet.password(min_length: 8, max_length: 20) }
    master_server { nil }
    premium_points { 1 }
    email { Faker::Internet.email }
  end
end
