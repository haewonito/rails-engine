FactoryBot.define do
  factory :invoice do
    association :customer
    association :merchant

    status { ["shipped", "returned", "package"].sample }
    # merchant { nil }
    # customer { nil }


  end
end
