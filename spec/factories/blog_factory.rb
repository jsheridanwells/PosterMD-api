FactoryBot.define do
  factory :blog do
    title { Faker::StarWars.call_sign }
    description { Faker::StarWars.quote }
  end
end