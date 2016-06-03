FactoryGirl.define do
  sequence :name do |n|
    "Example User#{n}"
  end
 
  # Reuses the sequence result: http://goo.gl/Ct80r5
  # Use a block to access your current object.
  factory :user do |u|
    name
    email { "#{u.name}@example.com" }
    department # association
  end
end
