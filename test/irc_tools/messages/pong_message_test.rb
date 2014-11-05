class PongMessageTest < Minitest::Test
  def test_to_s_is_correct
    assert_equal 'PONG', IrcTools::PongMessage.new.to_s
    assert_equal 'PONG :server', IrcTools::PongMessage.new(:server => 'server').to_s
  end
end