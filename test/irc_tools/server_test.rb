class ServerTest < Minitest::Test
  def setup
    @host_name = 'holmes.freenode.net'
    @port = 6667
    @server = IrcTools::Server.new(@host_name, @port)
  end

  def test_is_not_connected_at_first
    assert_equal false, @server.is_connected?
  end

  def test_is_connected_if_socket_init_succeeds
    mock_socket = mock('socket')
    TCPSocket.expects(:new).with(@host_name,@port).returns(mock_socket)

    assert_equal true, @server.connect
    assert_equal true, @server.connected
  end

  def test_is_not_connected_if_socket_init_fails
    mock_socket = mock('socket')
    TCPSocket.expects(:new).with(@host_name,@port).raises(Exception)

    assert_equal false, @server.connect
    assert_equal false, @server.connected
  end

  def test_read_raises_exception_if_not_connected
    assert_raises IrcTools::Server::NotConnectedException do
      @server.read
    end
  end

  def test_write_raises_exception_if_not_connected
    assert_raises IrcTools::Server::NotConnectedException do
      @server.write('message')
    end
  end

  def test_write_returns_true_if_socket_write_succeeds
    message = 'message'
    mock_socket = mock('socket')
    mock_socket.expects(:puts).with(message).returns(true)
    @server.expects(:socket).returns(mock_socket)
    @server.expects(:is_connected?).returns(true)

    assert_equal true, @server.write(message)
  end

  def test_write_returns_false_if_socket_write_fails
    message = 'message'
    mock_socket = mock('socket')
    mock_socket.expects(:puts).with(message).raises(Exception)
    @server.expects(:socket).returns(mock_socket)
    @server.expects(:is_connected?).returns(true)

    assert_equal false, @server.write(message)
  end

  def test_read_returns_message_if_socket_read_succeeds
    message = 'message'
    mock_socket = mock('socket')
    mock_socket.expects(:gets).returns(message)
    @server.expects(:socket).returns(mock_socket)
    @server.expects(:is_connected?).returns(true)

    assert_equal message, @server.read
  end

  def test_read_returns_nil_if_socket_read_fails
    mock_socket = mock('socket')
    mock_socket.expects(:gets).raises(Exception)
    @server.expects(:socket).returns(mock_socket)
    @server.expects(:is_connected?).returns(true)

    assert_equal nil, @server.read
  end

  def test_disconnect_closes_socket
    mock_socket = mock('socket')
    mock_socket.expects(:close)
    @server.expects(:socket).returns(mock_socket)

    @server.disconnect
  end
end