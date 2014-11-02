class JoinMessageTest < Minitest::Test
  def test_new_raises_argument_error_without_necessary_params
    assert_raises ArgumentError do
      IrcTools::JoinMessage.new(:key => 'key')
    end
  end

  def test_user_is_not_required
    refute_nil IrcTools::JoinMessage.new(:channel => '#channel')
  end

  def test_to_s_is_correct
    assert_equal 'JOIN #channel', IrcTools::JoinMessage.new(:channel => '#channel').to_s
    assert_equal 'JOIN #channel1,#channel2', IrcTools::JoinMessage.new(:channel => '#channel1,#channel2').to_s
    assert_equal 'JOIN #channel1,#channel2 key1,key2', IrcTools::JoinMessage.new(:channel => '#channel1,#channel2', :key => 'key1,key2').to_s
  end
end