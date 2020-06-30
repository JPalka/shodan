FactoryBot.define do
  factory :account do
    login { "test_login" }
    password { "random_password" }
    master_server { nil }
    premium_points { 1 }
    email { Faker::Internet.email }
  end
end
