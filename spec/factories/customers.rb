# FactoryBot.define do
#   factory :customer, class: Customer do
#     name { Faker::Name.name }
#     id { Faker::Number.unique.within(range: 1..10000000) }
#   end
# end

FactoryBot.define do
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    id { Faker::Number.unique.within(range: 1..10000000) }
  end
end
