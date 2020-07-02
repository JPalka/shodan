# frozen_string_literal: true

FactoryBot.define do
  factory :village do
    external_id { 1010 }
    x_coord { 100 }
    y_coord { 150 }
    owner factory: :player
    world
    points { 0 }
    name { 'MyVillage' }
  end
end
