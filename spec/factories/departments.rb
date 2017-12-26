# http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
FactoryGirl.define do
  sequence :dept_name do |n|
    "Department #{n}"
  end
 
  factory :department do
    dept_name
    location "Somewhere in the universe"
  
    factory :department_with_users do
      transient do
        user_count 3
      end
      
      after(:create) do |department, evaluator|
        create_list(:user, evaluator.user_count, department: department)
      end
    end
  end
end
