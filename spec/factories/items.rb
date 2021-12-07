FactoryBot.define do
  factory :item, class:Item do
    association :merchant

    name { Faker::Name.name }
    description { Faker::GreekPhilosophers.quote }
    unit_price { Faker::Commerce.price }
    id { Faker::Number.unique.within(range: 1..10000000) }
    # merchant { nil }
  end
end
