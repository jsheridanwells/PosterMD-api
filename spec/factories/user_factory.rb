FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email "#{first_name}@example.com"
    password '123456'
  end
end