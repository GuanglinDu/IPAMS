require 'test_helper'

class WelcomePolicyTest < ActiveSupport::TestCase
  def test_index
    assert WelcomePolicy.new(@tom, :welcome).index?
    assert WelcomePolicy.new(@jerry, :welcome).index?
    assert WelcomePolicy.new(@mary, :welcome).index?
    assert WelcomePolicy.new(@barack, :welcome).index?
    assert WelcomePolicy.new(@michelle, :welcome).index?
    assert WelcomePolicy.new(@hillary, :welcome).index?
  end

  def test_tip
    assert_not WelcomePolicy.new(@tom, :welcome).tip?
    assert_not WelcomePolicy.new(@jerry, :welcome).tip?
    assert_not WelcomePolicy.new(@mary, :welcome).tip?
    assert_not WelcomePolicy.new(@barack, :welcome).tip?
    assert_not WelcomePolicy.new(@michelle, :welcome).tip?
    assert WelcomePolicy.new(@hillary, :welcome).tip?
  end
end
