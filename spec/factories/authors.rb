FactoryBot.define do
  factory :author, class: Author do
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
  end

  factory :author_seq, class: Author do
    sequence(:first_name, (1..10).cycle) { |n| "fn-v#{n}" }
    sequence(:last_name, (1..10).cycle) { |n| "ln-v#{n}" }
  end

  factory :author_params, class: Hash do
    initialize_with { attributes_for(:author) }
  end
end
