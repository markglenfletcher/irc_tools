require 'test_helper'

class PassMessgeTest < Minitest::Test
  def test_new_raises_argument_error_without_PASSWORD
    assert_raises ArgumentError do
      IrcTools::PassMessage.new
    end
  end

  def test_to_s_is_correct
    assert_equal 'PASS pass', IrcTools::PassMessage.new(:password => 'pass').to_s
  end
end
