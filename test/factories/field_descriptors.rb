# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_descriptor do
    sequence(:name) { |n| "NodeDescriptor#{n}" }
    sequence(:field_type) { |n| "NodeDescriptor Type#{n}" }
  end
end
