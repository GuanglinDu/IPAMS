require 'test_helper'

# http://guides.rubyonrails.org/testing.html
# 3.3 What to Include in Your Unit Tests
# Include a test for everything which could possibly break.
# It's a good practice to have at least one test for each of your validations
# and at least one test for every method in your model.
class LanTest < ActiveSupport::TestCase
  def setup
    @lan = lans(:one)
  end

  test "attributes must not be empty" do
    lan = Lan.new
    assert lan.invalid?
    assert lan.errors[:lan_number].any?
    assert lan.errors[:lan_name].any?
    assert lan.errors[:lan_description].any?
  end

  test "lan is valid" do
    assert @lan.valid?, "lan should be valid"
    assert_equal 0, @lan.errors[:lan_number].count
    assert_equal 0, @lan.errors[:lan_name].count
    assert_equal 0, @lan.errors[:lan_description].count
  end

  test "lan name must be 5 char long at least" do
    @lan.lan_name = "bla"
    assert @lan.invalid?, "Description should be longer than 5 characters"
    # Note: Hardcoded expected error message
    assert_equal ["is too short (minimum is 5 characters)"],
                 @lan.errors[:lan_name]
  end

  test "description must be 5 char long at least" do
    @lan.lan_description = "bla"
    assert @lan.invalid?, "Should be invalid"
    assert_equal ["is too short (minimum is 5 characters)"],
                 @lan.errors[:lan_description]
  end

  # Note: Fixtures are Active Record objects!
  # http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures
  test "should be invalid without a unique lan_number" do
    lan = Lan.new lan_number: @lan.lan_number,
                  lan_name: "Main Building",
                  lan_description: "Bla bla bla bal"
    assert lan.invalid?, "lan_number must be unique"    
    assert_equal ["has already been taken"], lan.errors[:lan_number]
  end

  test "should be invalid without a unique lan_name" do
    lan = Lan.new lan_number: 1002,
                  lan_name: @lan.lan_name,
                  lan_description: "Bla bla bla bal"
    assert lan.invalid?, "lan_name must be unique"    

    # If you want to avoid using a hardcoded string for the Active Record error,
    # you can compare the response against its built-in error message table.
    #assert_equal ["has already been taken"], lan.errors[:lan_name]
    assert_equal [I18n.translate('errors.messages.taken')],
                 lan.errors[:lan_name]
  end
end
