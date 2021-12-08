FactoryBot.define do
  factory :customer do
    first_name { "MyString" }
    last_name { "MyString" }
    id { Faker::Number.unique.within(range: 1..10000000) }
  end
end
