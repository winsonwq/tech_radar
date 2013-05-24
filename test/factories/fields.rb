# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field do
  	sequence(:data) { |n| "field data #{n}" }
  	field_descriptor
  end
end
