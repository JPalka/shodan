FactoryBot.define do
  factory :account do
    login { "MyString" }
    password { "MyString" }
    master_server { nil }
    premium_points { 1 }
    email { Faker::Internet.email }
  end
end
