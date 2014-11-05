require 'test_helper'

class QuitMessageTest < Minitest::Test
  def test_message_is_not_required
    refute_nil IrcTools::QuitMessage.new
  end

  def test_to_s_is_correct
    assert_equal 'QUIT :Gone Dinner', IrcTools::QuitMessage.new(:message => 'Gone Dinner').to_s
    assert_equal 'QUIT', IrcTools::QuitMessage.new.to_s
  end
end