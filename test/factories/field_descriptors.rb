# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_descriptor do
    sequence(:name) { |n| "FieldDescriptor#{n}" }
    sequence(:field_type) { |n| "FieldDescriptor Type#{n}" }
  end
end
