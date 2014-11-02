class PrivmsgMessageTest < Minitest::Test
  def test_new_raises_argument_error_without_necessary_params
    assert_raises ArgumentError do
      IrcTools::PrivmsgMessage.new
    end
  end

  def test_to_s_is_correct
    assert_equal 'PRIVMSG user :My Message', IrcTools::PrivmsgMessage.new(:recipient => 'user', :message => 'My Message').to_s
  end
end