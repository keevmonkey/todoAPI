# spec/factories/items.rb
FactoryBot.define do
  factory :items do
    name { Faker::StarWars.character }
    done false
    todo_id nil
  end
end

