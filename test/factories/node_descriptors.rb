# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :node_descriptor do
    sequence(:name) { |n| "NodeDescriptor#{n}" }
  end
end
