require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# 3.3 What to Include in Your Unit Tests
# Ideally, you would like to include a test for everything which could possibly break.
# It's a good practice to have at least one test for each of your validations
# and at least one test for every method in your model.
class LanTest < ActiveSupport::TestCase
  # All fixtures were already loaded in test_helper.rb
  #fixtures :lans

  #setup do
  #  @lan = Lan.new
  #end

  # New Lan with all attributes empty should be invalid, i.e.,
  # lan_number, lan_name, lan_description presence validation
  test "attributes must not be empty" do
    lan1 = Lan.new
    assert lan1.invalid?, "Lan object with all attributes empty should be invalid"
    assert lan1.errors[:lan_number].any?, "lan_number must not be blank"
    assert lan1.errors[:lan_name].any?, "lan_name must not be blank"
    assert lan1.errors[:lan_description].any?, "lan_description must not be blank"
  end

  # lan_name length validation
  test "lan_name must be 5-char long at least" do
    lan2 = Lan.new(lan_number: 1000, lan_name: "Main Building 1000",
      lan_description: "Bla bla bla bal")

    assert lan2.valid?, "lan should be valid"
    assert_equal [], lan2.errors[:lan_name] # nil error

    lan2.lan_name = "bla"
    assert lan2.invalid?, "lan should be invalid with description shorter than 5 characters"
    # Notice: Hardcoded expected error message
    assert_equal ["is too short (minimum is 5 characters)"], lan2.errors[:lan_name]
  end

  # lan_description length validation
  test "description must be 5-char long at minimum" do
    lan3 = Lan.new(lan_number: 1001, lan_name: "Main Building 1001",
      lan_description: "Bla bla bla bal")

    assert lan3.valid?, "lan should be valid"
    assert_equal [], lan3.errors[:lan_description] # the latter returns a nill Array [] 

    lan3.lan_description = "bla"
    assert lan3.invalid?, "Lan should be invalid with description shorter than 5-char"
    assert_equal ["is too short (minimum is 5 characters)"], lan3.errors[:lan_description]
  end

  # lan_number uniqueness validation against fixture one
  # Note: Fixtures are Active Record objects!
  # http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures
  test "should be invalid without a unique lan_number" do
    lan4 = Lan.new(lan_number: lans(:one).lan_number, lan_name: "Main Building",
      lan_description: "Bla bla bla bal")
    assert lan4.invalid?, "lan_number must be unique"    
    assert_equal ["has already been taken"], lan4.errors[:lan_number]
  end

  # lan_name uniqueness validation against fixture one
  test "should be invalid without a unique lan_name" do
    lan5 = Lan.new(lan_number: 1002, lan_name: lans(:one).lan_name,
      lan_description: "Bla bla bla bal")
    assert lan5.invalid?, "lan_name must be unique"    

    # If you want to avoid using a hard-coded string for the Active Record error,
    # you can compare the response against its built-in error message table.
    #assert_equal ["has already been taken"], lan5.errors[:lan_name]
    assert_equal [I18n.translate('errors.messages.taken')], lan5.errors[:lan_name]
  end
end
