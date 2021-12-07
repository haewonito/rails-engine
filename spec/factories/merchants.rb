FactoryBot.define do
  factory :merchant, class: Merchant do
    name { Faker::Name.name }
    id { Faker::Number.unique.within(range: 1..10000000) }
  end
end
