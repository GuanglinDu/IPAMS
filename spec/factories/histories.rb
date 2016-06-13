# http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
FactoryGirl.define do
  # Reuses the sequence result: http://goo.gl/Ct80r5
  # Use a block to access your current object.
  factory :history do |his|
    usage "PC-office"
    user_name "User1"
    address # association
  end
end
