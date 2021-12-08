FactoryBot.define do
  factory :invoice do
    status { Faker::Verb.ing_form }
    id { Faker::Number.unique.within(range: 1..10000000) }
    # customer { nil }
    # merchant { nil }
  end
end
