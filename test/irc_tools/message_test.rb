require 'test_helper'

class MessageTest < Minitest::Test
  def test_method_symbol_is_correct
    assert_equal 'on_privmsg_messages', IrcTools::Message.new(":Angel PRIVMSG Wiz :Hello are you receiving this message ?").method_symbol
  end

  def test_new_doesnt_blow_up_with_unknown_message
    refute_nil IrcTools::Message.new(":holmes.freenode.net 002 swarmhorderrndm :Your host is holmes.freenode.net[83.170.73.249/6667], running version ircd-seven-1.1.3")
  end

  def test_parsed_message_behaves_correctly
    # Test some common message types are constructed properly

    # PASS
    message = 'PASS password'
    assert_irc_message_contains IrcTools::Message.parse(message), :password => 'password', :type => :pass, :raw_message => message

    # NICK
    message = ':prev NICK nick'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'prev', :nickname => 'nick'

    # USER

    message = 'USER guest tolmoon tolsun :Ronnie Reagan'
    assert_irc_message_contains IrcTools::Message.parse(message), :username => 'guest', :hostname => 'tolmoon', :servername => 'tolsun', :realname => 'Ronnie Reagan'

    # QUIT
    message = ':syrk!kalt@millennium.stealth.net QUIT :Gone to have lunch'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'syrk!kalt@millennium.stealth.net', :message => 'Gone to have lunch'

    # JOIN
    message = ':WiZ!jto@tolsun.oulu.fi JOIN #Twilight_zone'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#Twilight_zone'

    # PART
    message = ':WiZ!jto@tolsun.oulu.fi PART #playzone :I lost'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#playzone', :message => 'I lost'

    # MODE Channel

    message = 'MODE #Finnish +v Wiz'
    assert_irc_message_contains IrcTools::Message.parse(message), :channel => '#Finnish', :operator => '+', :mode => 'v', :user => 'Wiz'

    message = ':WiZ!jto@tolsun.oulu.fi MODE #eu-opers -l'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#eu-opers', :operator => '-', :mode => 'l'

    # MODE User
    message = ':Angel MODE Angel :+i'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'Angel', :recipient => 'Angel', :operator => '+', :mode => 'i'

    # TOPIC
    message = ':WiZ!jto@tolsun.oulu.fi TOPIC #test :New topic'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#test', :topic => 'New topic'

    # INVITE
    message = ':Angel INVITE Wiz #Dust'
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'Angel', :recipient => 'Wiz', :channel => '#Dust'

    # KICK
    message = 'KICK &Melbourne Matthew'
    assert_irc_message_contains IrcTools::Message.parse(message), :channel => '&Melbourne', :recipient => 'Matthew' 

    # PRIVMSG
    message = ":Angel PRIVMSG Wiz :Hello are you receiving this message ?"
    assert_irc_message_contains IrcTools::Message.parse(message), :user => 'Angel', :recipient => 'Wiz', :message => 'Hello are you receiving this message ?'

    # NOTICE
    message = 'NOTICE Wiz!jto@tolsun.oulu.fi :Hello !'
    assert_irc_message_contains IrcTools::Message.parse(message), :recipient => 'Wiz!jto@tolsun.oulu.fi', :message => 'Hello !'

    # PING
    message = 'PING tolsun.oulu.fi'
    assert_irc_message_contains IrcTools::Message.parse(message), :server => 'tolsun.oulu.fi'
 
    # PONG
    message = 'PONG csd.bu.edu tolsun.oulu.fi'
    assert_irc_message_contains IrcTools::Message.parse(message), :daemon => 'csd.bu.edu tolsun.oulu.fi'

    # AWAY
    message = 'AWAY :Gone to lunch.  Back in 5'
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :away, :message => 'Gone to lunch.  Back in 5'

    message = ':WiZ AWAY'
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :away, :user => 'WiZ'
  end

  def test_numeric_messages_processed_correctly
    message = ':holmes.freenode.net 001 rubybottesting :Welcome to the freenode Internet Relay Chat Network rubybottesting'
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :'001', :user => 'holmes.freenode.net', :recipient => 'rubybottesting', :message => ':Welcome to the freenode Internet Relay Chat Network rubybottesting'
  
    message = ":holmes.freenode.net 251 rubybottesting :There are 179 users and 88418 invisible on 30 servers"
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :'251', :user => 'holmes.freenode.net', :recipient => 'rubybottesting', :message => ':There are 179 users and 88418 invisible on 30 servers'

    message = ':holmes.freenode.net 252 rubybottesting 31 :IRC Operators online'
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :'252', :user => 'holmes.freenode.net', :recipient => 'rubybottesting', :message => '31 :IRC Operators online'

    message = ':holmes.freenode.net 253 rubybottesting 9 :unknown connection(s)'
    assert_irc_message_contains IrcTools::Message.parse(message), :type => :'253', :user => 'holmes.freenode.net', :recipient => 'rubybottesting', :message => '9 :unknown connection(s)'
  end

  def test_validates_message_recognises_valid_message
    assert_equal false, IrcTools::Message.validate_message('PASS pass').nil?
  end

  def test_new_accepts_hash
    refute_nil IrcTools::Message.new({:user=>"prev", :type=>:nick, :nickname=>"nick", :raw_message=>":prev NICK nick"})
  end

  def test_generic_irc_message_to_is_is_valid
    assert_equal ':user 123 recipient :message', IrcTools::Message.new(:type => :'123', :user => 'user', :recipient => 'recipient', :message => ':message').to_s
  end

  private

  def assert_irc_message_contains(irc_message, contents = {})
    contents.each { |k,v| assert_equal v, irc_message[k] }
  end
end
