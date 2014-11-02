class UserMessageTest < Minitest::Test
  def test_new_raises_argument_error_without_necessary_params
    assert_raises ArgumentError do
      IrcTools::UserMessage.new
    end
  end

  def test_to_s_is_correct
    assert_equal 'USER guest 8 * :Ronnie Reagan', IrcTools::UserMessage.new(:nickname => 'guest', :mode => '8', :realname => 'Ronnie Reagan').to_s
    assert_equal 'USER guest 0 * :Ronnie Reagan', IrcTools::UserMessage.new(:nickname => 'guest', :mode => '0', :realname => 'Ronnie Reagan').to_s
  end
end