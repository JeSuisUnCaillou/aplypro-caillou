# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    pfmp
    amount { Faker::Number.positive }

    trait :processing do
      after(:create, &:process!)
    end

    trait :successful do
      processing

      after(:create, &:complete!)
    end

    trait :failed do
      processing

      after(:create, &:fail!)
    end
  end
end
