require 'test_helper'

class LanTest < ActiveSupport::TestCase
  # All fixtures are already loaded in test_helper.rb
  #fixtures :lans

  #setup do
  #  @lan = Lan.new
  #end

  # New Lan with all attributes empty should be invalid
  test "LAN attributes must not be empty" do
    @lan = Lan.new
    assert @lan.invalid?
    assert @lan.errors[:lan_number].any?
    assert @lan.errors[:lan_name].any?
    assert @lan.errors[:lan_description].any?
  end

  # lan_name length validation
  test "LAN name must be 5-char long at minimum" do
    lan = Lan.new(lan_number: 101, lan_name: "Main Building",
      lan_description: "Bla bla bla bal")

    assert lan.valid?, "lan should be valid"
    assert_equal [], lan.errors[:lan_name] # nill error

    lan.lan_name = "bla"
    assert lan.invalid?, "lan should be invalid with description shorter than 5-char"
    assert_equal ["is too short (minimum is 5 characters)"], lan.errors[:lan_name]
  end

  # lan_description length validation
  test "LAN description must be 5-char long at minimum" do
    lan = Lan.new(lan_number: 101, lan_name: "Main Building",
      lan_description: "Bla bla bla bal")

    assert lan.valid?, "lan should be valid"
    assert_equal [], lan.errors[:lan_description] # nill error

    lan.lan_description = "bla"
    assert lan.invalid?, "lan should be invalid with description shorter than 5-char"
    assert_equal ["is too short (minimum is 5 characters)"], lan.errors[:lan_description]
  end

  # lan_number uniqueness validation with fixtures
  test "A LAN is not valid without a unique lan_number" do
    lan = Lan.new(lan_number: lans(:one).lan_number, lan_name: "Main Building",
      lan_description: "Bla bla bla bal")
    assert lan.invalid?, "lan_number must be unique"    
    assert_equal ["has already been taken"], lan.errors[:lan_number]
  end

  # lan_name uniqueness validation with fixtures
  test "A LAN is not valid without a unique lan_name" do
    lan = Lan.new(lan_number: 10, lan_name: lans(:one).lan_name,
      lan_description: "Bla bla bla bal")
    assert lan.invalid?, "lan_name must be unique"    

    # If you want to avoid using a hard-coded string for the Active Record error,
    # you can compare the response against its built-in error message table.
    #assert_equal ["has already been taken"], lan.errors[:lan_name]
    assert_equal [I18n.translate('errors.messages.taken')], lan.errors[:lan_name]
  end
end
