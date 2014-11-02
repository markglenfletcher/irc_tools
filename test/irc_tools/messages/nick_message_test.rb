require 'test_helper'

class NickMessageTest < Minitest::Test
  def test_new_raises_argument_error_with_nickname
    assert_raises ArgumentError do
      IrcTools::NickMessage.new
    end
  end

  def test_user_is_not_required
    refute_nil IrcTools::NickMessage.new(:nickname => 'nick')
  end

  def test_to_s_is_correct
    assert_equal ':prev NICK nick', IrcTools::NickMessage.new(:user => 'prev', :nickname => 'nick').to_s
    assert_equal 'NICK nick', IrcTools::NickMessage.new(:nickname => 'nick').to_s
    assert_equal ':WiZ!jto@tolsun.oulu.fi NICK Kilroy', IrcTools::NickMessage.new(:user => 'WiZ!jto@tolsun.oulu.fi', :nickname => 'Kilroy').to_s
  end
end