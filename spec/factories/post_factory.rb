FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraphs(5) }
    published { Faker::Boolean.boolean(0.8) }
  end
end