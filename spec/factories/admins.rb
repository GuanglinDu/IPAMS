require 'faker'

# See http://goo.gl/F1MKTg
# See also http://goo.gl/F1MKTg
FactoryGirl.define do
  factory :admin do
    # {} is crucial. See http://goo.gl/CDO3qP
    email { Faker::Internet.email }
    password "password"

    trait :root do
      role :root
    end

    trait :vip do
      role :vip
    end

    trait :expert do
      role :expert
    end

    trait :operator do
      role :operator
    end

    trait :guest do
      role :guest
    end

    trait :nobody do
      role :nobody
    end
  end
end
