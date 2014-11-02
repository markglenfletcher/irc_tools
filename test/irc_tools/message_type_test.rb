class MessageTypeTest < Minitest::Test
  def test_matchers_work
    # PASS
    message = 'PASS password'
    message_matches = IrcTools::MessageTypes::PASS_MATCHER.match message
    assert_message_matches message_matches, :password => 'password', :type => 'PASS'

    # NICK
    message = ':prev NICK nick'
    message_matches = IrcTools::MessageTypes::NICK_MATCHER.match message
    assert_message_matches message_matches, :user => 'prev', :nickname => 'nick'

    message = 'NICK nick'
    message_matches = IrcTools::MessageTypes::NICK_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'nick'

    message = ':WiZ!jto@tolsun.oulu.fi NICK Kilroy'
    message_matches = IrcTools::MessageTypes::NICK_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :nickname => 'Kilroy'

    # USER

    message = 'USER guest tolmoon tolsun :Ronnie Reagan'
    message_matches = IrcTools::MessageTypes::USER_MATCHER.match message
    assert_message_matches message_matches, :username => 'guest', :hostname => 'tolmoon', :servername => 'tolsun', :realname => 'Ronnie Reagan'
    
    message = ':testnick USER guest tolmoon tolsun :Ronnie Reagan'
    message_matches = IrcTools::MessageTypes::USER_MATCHER.match message
    assert_message_matches message_matches, :user => 'testnick', :username => 'guest', :hostname => 'tolmoon', :servername => 'tolsun', :realname => 'Ronnie Reagan'

    # SERVER
    message = 'SERVER test.oulu.fi 1 :[tolsun.oulu.fi] Experimental server'
    message_matches = IrcTools::MessageTypes::SERVER_MATCHER.match message
    assert_message_matches message_matches, :servername => 'test.oulu.fi', :hopcount =>  '1', :info => '[tolsun.oulu.fi] Experimental server'
    
    message = ':tolsun.oulu.fi SERVER csd.bu.edu 5 :BU Central Server'
    message_matches = IrcTools::MessageTypes::SERVER_MATCHER.match message
    assert_message_matches message_matches, :user => 'tolsun.oulu.fi', :servername => 'csd.bu.edu', :hopcount => '5', :info => 'BU Central Server'

    # OPER
    message = 'OPER foo bar'
    message_matches = IrcTools::MessageTypes::OPER_MATCHER.match message
    assert_message_matches message_matches, :user => 'foo', :password => 'bar'

    # QUIT
    message = 'QUIT :Gone to have lunch'
    message_matches = IrcTools::MessageTypes::QUIT_MATCHER.match message
    assert_message_matches message_matches, :message => 'Gone to have lunch'

    message = ':syrk!kalt@millennium.stealth.net QUIT :Gone to have lunch'
    message_matches = IrcTools::MessageTypes::QUIT_MATCHER.match message
    assert_message_matches message_matches, :user => 'syrk!kalt@millennium.stealth.net', :message => 'Gone to have lunch'

    # SQUIT 
    message = 'SQUIT tolsun.oulu.fi :Bad Link ?'
    message_matches = IrcTools::MessageTypes::SQUIT_MATCHER.match message
    assert_message_matches message_matches, :server => 'tolsun.oulu.fi',:comment => 'Bad Link ?'
        
    message = ':Trillian SQUIT cm22.eng.umd.edu :Server out of control'
    message_matches = IrcTools::MessageTypes::SQUIT_MATCHER.match message
    assert_message_matches message_matches, :user => 'Trillian', :server => 'cm22.eng.umd.edu', :comment => 'Server out of control' 

    # JOIN

    message = 'JOIN #foobar'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :channel => '#foobar'

    message ='JOIN &foo fubar'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :channel => '&foo', :key => 'fubar'

    message = 'JOIN #foo,&bar fubar'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :channel => '#foo,&bar', :key => 'fubar'
    
    message = 'JOIN #foo,#bar fubar,foobar'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :channel => '#foo,#bar', :key => 'fubar,foobar'
    
    message = 'JOIN #foo,#bar'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :channel => '#foo,#bar'

    message = ':WiZ JOIN #Twilight_zone'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ', :channel => '#Twilight_zone'

    message = ':WiZ!jto@tolsun.oulu.fi JOIN #Twilight_zone'
    message_matches = IrcTools::MessageTypes::JOIN_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#Twilight_zone'

    # PART

    message = 'PART #twilight_zone'
    message_matches = IrcTools::MessageTypes::PART_MATCHER.match message
    assert_message_matches message_matches, :channel => '#twilight_zone'

    message = 'PART #oz-ops,&group5'
    message_matches = IrcTools::MessageTypes::PART_MATCHER.match message
    assert_message_matches message_matches, :channel => '#oz-ops,&group5'

    message = ':WiZ!jto@tolsun.oulu.fi PART #playzone :I lost'
    message_matches = IrcTools::MessageTypes::PART_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#playzone', :message => 'I lost'

    # MODE Channel

    message = 'MODE #Finnish +v Wiz'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '#Finnish', :operator => '+', :mode => 'v', :user => 'Wiz'

    message = 'MODE #Fins -s'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '#Fins', :operator => '-', :mode => 's'

    message = 'MODE #42 +k oulu'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '#42', :operator => '+', :mode => 'k', :user => 'oulu'
    
    message = 'MODE #eu-opers +l 10'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '#eu-opers', :operator => '+', :mode => 'l', :limit => '10'

    message = 'MODE &oulu +b'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '&oulu', :operator => '+', :mode => 'b'

    message = 'MODE &oulu +b *!*@*'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '&oulu', :operator => '+', :mode => 'b', :banmask => '*!*@*'

    message = 'MODE &oulu +b *!*@*.edu'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :channel => '&oulu', :operator => '+', :mode => 'b', :banmask => '*!*@*.edu'
    
    message = ':WiZ!jto@tolsun.oulu.fi MODE #eu-opers -l'
    message_matches = IrcTools::MessageTypes::CHANNEL_MODE_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#eu-opers', :operator => '-', :mode => 'l'

    # MODE User

    message = ':WiZ MODE :-w'
    message_matches = IrcTools::MessageTypes::USER_MODE_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ', :operator => '-', :mode => 'w'

    message = ':Angel MODE Angel :+i'
    message_matches = IrcTools::MessageTypes::USER_MODE_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel', :recipient => 'Angel', :operator => '+', :mode => 'i'

    message = 'MODE WiZ :-o'
    message_matches = IrcTools::MessageTypes::USER_MODE_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'WiZ', :operator => '-', :mode => 'o'

    # TOPIC

    message = ':WiZ!jto@tolsun.oulu.fi TOPIC #test :New topic'
    message_matches = IrcTools::MessageTypes::TOPIC_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#test', :topic => 'New topic'
    
    message = 'TOPIC #test :another topic'
    message_matches = IrcTools::MessageTypes::TOPIC_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :channel => '#test', :topic => 'another topic'

    message = 'TOPIC #test :'
    message_matches = IrcTools::MessageTypes::TOPIC_MATCHER.match message
    assert_message_matches message_matches, :channel => '#test', :topic => ''

    message = 'TOPIC #test'
    message_matches = IrcTools::MessageTypes::TOPIC_MATCHER.match message
    assert_message_matches message_matches, :channel => '#test'    

    # NAMES

    message = 'NAMES #twilight_zone,#42'
    message_matches = IrcTools::MessageTypes::NAMES_MATCHER.match message
    assert_message_matches message_matches, :channel => '#twilight_zone,#42'

    message = 'NAMES'
    message_matches = IrcTools::MessageTypes::NAMES_MATCHER.match message
    assert_message_matches message_matches, :type => 'NAMES', :channel => nil

    # LIST

    message = 'LIST'
    message_matches = IrcTools::MessageTypes::LIST_MATCHER.match message
    assert_message_matches message_matches, :type => 'LIST', :channel => nil
    
    message = 'LIST #twilight_zone,#42'
    message_matches = IrcTools::MessageTypes::LIST_MATCHER.match message
    assert_message_matches message_matches, :channel => '#twilight_zone,#42'

    # INVITE
    message = ':Angel INVITE Wiz #Dust'
    message_matches = IrcTools::MessageTypes::INVITE_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel', :recipient => 'Wiz', :channel => '#Dust'

    message = 'INVITE Wiz #Twilight_Zone'
    message_matches = IrcTools::MessageTypes::INVITE_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'Wiz', :channel => '#Twilight_Zone'

    message = ':Angel!wings@irc.org INVITE Wiz #Dust'
    message_matches = IrcTools::MessageTypes::INVITE_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel!wings@irc.org', :recipient => 'Wiz', :channel => '#Dust'

    # KICK

    message = 'KICK &Melbourne Matthew'
    message_matches = IrcTools::MessageTypes::KICK_MATCHER.match message
    assert_message_matches message_matches, :channel => '&Melbourne', :recipient => 'Matthew' 

    message = 'KICK #Finnish John :Speaking English'
    message_matches = IrcTools::MessageTypes::KICK_MATCHER.match message
    assert_message_matches message_matches, :channel => '#Finnish', :recipient => 'John', :message => 'Speaking English'

    message = ':WiZ KICK #Finnish John'
    message_matches = IrcTools::MessageTypes::KICK_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ', :channel => '#Finnish', :recipient => 'John'
    
    message = ':WiZ!jto@tolsun.oulu.fi KICK #Finnish John'
    message_matches = IrcTools::MessageTypes::KICK_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ!jto@tolsun.oulu.fi', :channel => '#Finnish', :recipient => 'John'

    # PRIVMSG
    message = ":Angel PRIVMSG Wiz :Hello are you receiving this message ?"
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel', :recipient => 'Wiz', :message => 'Hello are you receiving this message ?'

    message = "PRIVMSG Angel :yes I'm receiving it !"
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => 'Angel', :message => "yes I'm receiving it !"
    
    message = "PRIVMSG jto@tolsun.oulu.fi :Hello !"
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => 'jto@tolsun.oulu.fi', :message => 'Hello !'
    
    message = "PRIVMSG $*.fi :Server tolsun.oulu.fi rebooting."
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => '$*.fi', :message => 'Server tolsun.oulu.fi rebooting.'

    message = "PRIVMSG #*.edu :NSFNet is undergoing work, expect interruptions"
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => '#*.edu', :message => 'NSFNet is undergoing work, expect interruptions'

    message = 'PRIVMSG kalt%millennium.stealth.net@irc.stealth.net :Are you a frog?'
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'kalt%millennium.stealth.net@irc.stealth.net', :message => 'Are you a frog?'

    message = 'PRIVMSG kalt%millennium.stealth.net :Do you like cheese?'
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'kalt%millennium.stealth.net', :message => 'Do you like cheese?'

    message = 'PRIVMSG Wiz!jto@tolsun.oulu.fi :Hello !'
    message_matches = IrcTools::MessageTypes::PRIVMSG_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'Wiz!jto@tolsun.oulu.fi', :message => 'Hello !'

    # NOTICE
    message = ":Angel NOTICE Wiz :Hello are you receiving this message ?"
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel', :recipient => 'Wiz', :message => 'Hello are you receiving this message ?'

    message = "NOTICE Angel :yes I'm receiving it !"
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => 'Angel', :message => "yes I'm receiving it !"
    
    message = "NOTICE jto@tolsun.oulu.fi :Hello !"
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => 'jto@tolsun.oulu.fi', :message => 'Hello !'

    message = "NOTICE $*.fi :Server tolsun.oulu.fi rebooting."
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => '$*.fi', :message => 'Server tolsun.oulu.fi rebooting.'

    message = "NOTICE #*.edu :NSFNet is undergoing work, expect interruptions"
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :user => nil, :recipient => '#*.edu', :message => 'NSFNet is undergoing work, expect interruptions'

    message = 'NOTICE kalt%millennium.stealth.net@irc.stealth.net :Are you a frog?'
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'kalt%millennium.stealth.net@irc.stealth.net', :message => 'Are you a frog?'

    message = 'NOTICE kalt%millennium.stealth.net :Do you like cheese?'
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'kalt%millennium.stealth.net', :message => 'Do you like cheese?'

    message = 'NOTICE Wiz!jto@tolsun.oulu.fi :Hello !'
    message_matches = IrcTools::MessageTypes::NOTICE_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'Wiz!jto@tolsun.oulu.fi', :message => 'Hello !'

    # MOTD

    message = 'MOTD'
    message_matches = IrcTools::MessageTypes::MOTD_MATCHER.match message
    assert_message_matches message_matches, :type => 'MOTD'

    # STATS
    message = 'STATS m'
    message_matches = IrcTools::MessageTypes::STATS_MATCHER.match message
    assert_message_matches message_matches, :type => 'STATS', :query => 'm'

    message = ':Wiz STATS c eff.org'
    message_matches = IrcTools::MessageTypes::STATS_MATCHER.match message
    assert_message_matches message_matches, :user => 'Wiz', :query => 'c', :target => 'eff.org'

    # VERSION

    message = ':Wiz VERSION *.se'
    message_matches = IrcTools::MessageTypes::VERSION_MATCHER.match message
    assert_message_matches message_matches, :user => 'Wiz', :target => '*.se'

    message = 'VERSION tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::VERSION_MATCHER.match message
    assert_message_matches message_matches, :target => 'tolsun.oulu.fi'

    # LINKS

    message = 'LINKS *.au'
    message_matches = IrcTools::MessageTypes::LINKS_MATCHER.match message
    assert_message_matches message_matches, :servermask => '*.au'

    message = 'LINKS *.bu.edu *.edu'
    message_matches = IrcTools::MessageTypes::LINKS_MATCHER.match message
    assert_message_matches message_matches, :remoteserver => '*.bu.edu', :servermask => '*.edu'

    # TIME

    message = 'TIME tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::TIME_MATCHER.match message
    assert_message_matches message_matches, :target => 'tolsun.oulu.fi'
    
    message = ':Angel TIME *.au'
    message_matches = IrcTools::MessageTypes::TIME_MATCHER.match message
    assert_message_matches message_matches, :user => 'Angel', :target => '*.au'

    # CONNECT
    message = 'CONNECT tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::CONNECT_MATCHER.match message
    assert_message_matches message_matches, :target => 'tolsun.oulu.fi'

    message = ':WiZ CONNECT eff.org 6667 csd.bu.edu'
    message_matches = IrcTools::MessageTypes::CONNECT_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ', :target => 'eff.org', :port => '6667', :remoteserver => 'csd.bu.edu'

    # TRACE
    message = 'TRACE *.oulu.fi'
    message_matches = IrcTools::MessageTypes::TRACE_MATCHER.match message
    assert_message_matches message_matches, :target => '*.oulu.fi'
    
    message = ':WiZ TRACE AngelDust'
    message_matches = IrcTools::MessageTypes::TRACE_MATCHER.match message
    assert_message_matches message_matches, :user => 'WiZ', :target => 'AngelDust'

    # ADMIN

    message = 'ADMIN tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::ADMIN_MATCHER.match message
    assert_message_matches message_matches, :target => 'tolsun.oulu.fi'

    message = ':WiZ ADMIN *.edu'
    message_matches = IrcTools::MessageTypes::ADMIN_MATCHER.match message
    assert_message_matches message_matches, :target => '*.edu'

    message = 'ADMIN syrk'
    message_matches = IrcTools::MessageTypes::ADMIN_MATCHER.match message
    assert_message_matches message_matches, :target => 'syrk'

    # INFO

    message = 'INFO csd.bu.edu'
    message_matches = IrcTools::MessageTypes::INFO_MATCHER.match message
    assert_message_matches message_matches, :target => 'csd.bu.edu'

    message = ':Avalon INFO *.fi'
    message_matches = IrcTools::MessageTypes::INFO_MATCHER.match message
    assert_message_matches message_matches, :user => 'Avalon', :target => '*.fi'

    message = 'INFO Angel'
    message_matches = IrcTools::MessageTypes::INFO_MATCHER.match message
    assert_message_matches message_matches, :target => 'Angel'

    # SERVLIST
    # TODO

    # SQUERY

    message = 'SQUERY irchelp :HELP privmsg'
    message_matches = IrcTools::MessageTypes::SQUERY_MATCHER.match message
    assert_message_matches message_matches, :service => 'irchelp', :message => 'HELP privmsg'

    message = 'SQUERY dict@irc.fr :fr2en blaireau'
    message_matches = IrcTools::MessageTypes::SQUERY_MATCHER.match message
    assert_message_matches message_matches, :service => 'dict@irc.fr', :message => 'fr2en blaireau'

    # WHO

    message = 'WHO *.fi'
    message_matches = IrcTools::MessageTypes::WHO_MATCHER.match message
    assert_message_matches message_matches, :mask => '*.fi', :o => nil 

    message = 'WHO jto* o'
    message_matches = IrcTools::MessageTypes::WHO_MATCHER.match message
    assert_message_matches message_matches, :mask => 'jto*', :o => 'o'

    # WHOIS

    message = 'WHOIS wiz'
    message_matches = IrcTools::MessageTypes::WHOIS_MATCHER.match message
    assert_message_matches message_matches, :target => 'wiz'

    message = 'WHOIS eff.org trillian'
    message_matches = IrcTools::MessageTypes::WHOIS_MATCHER.match message
    assert_message_matches message_matches, :target => 'eff.org', :mask => 'trillian'

    # WHOWAS

    message = 'WHOWAS Wiz'
    message_matches = IrcTools::MessageTypes::WHOWAS_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'Wiz'

    message = 'WHOWAS Mermaid 9'
    message_matches = IrcTools::MessageTypes::WHOWAS_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'Mermaid', :count => '9'
    
    message = 'WHOWAS Trillian 1 *.edu'
    message_matches = IrcTools::MessageTypes::WHOWAS_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'Trillian', :count => '1', :target => '*.edu'

    # KILL
    message = 'KILL David (csd.bu.edu <- tolsun.oulu.fi)'
    message_matches = IrcTools::MessageTypes::KILL_MATCHER.match message
    assert_message_matches message_matches, :type => 'KILL', :nickname => 'David', :comment => '(csd.bu.edu <- tolsun.oulu.fi)'

    # PING
    message = 'PING tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::PING_MATCHER.match message
    assert_message_matches message_matches, :server => 'tolsun.oulu.fi'

    message = 'PING WiZ'
    message_matches = IrcTools::MessageTypes::PING_MATCHER.match message
    assert_message_matches message_matches, :server => 'WiZ'
  
    # PONG
    message = 'PONG'
    message_matches = IrcTools::MessageTypes::PONG_MATCHER.match message
    assert_message_matches message_matches, :type => 'PONG'

    message = 'PONG csd.bu.edu'
    message_matches = IrcTools::MessageTypes::PONG_MATCHER.match message
    assert_message_matches message_matches, :daemon => 'csd.bu.edu'

    message = 'PONG csd.bu.edu tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::PONG_MATCHER.match message
    assert_message_matches message_matches, :daemon => 'csd.bu.edu tolsun.oulu.fi'

    # ERROR
    message = 'ERROR :Server *.fi already exists'
    message_matches = IrcTools::MessageTypes::ERROR_MATCHER.match message
    assert_message_matches message_matches, :type => 'ERROR', :message => 'Server *.fi already exists'

    # AWAY
    message = 'AWAY :Gone to lunch.  Back in 5'
    message_matches = IrcTools::MessageTypes::AWAY_MATCHER.match message
    assert_message_matches message_matches, :type => 'AWAY', :message => 'Gone to lunch.  Back in 5'

    message = ':WiZ AWAY'
    message_matches = IrcTools::MessageTypes::AWAY_MATCHER.match message
    assert_message_matches message_matches, :type => 'AWAY', :user => 'WiZ'

    # REHASH
    message = 'REHASH'
    message_matches = IrcTools::MessageTypes::REHASH_MATCHER.match message
    assert_message_matches message_matches, :type => 'REHASH'

    # RESTART
    message = 'RESTART'
    message_matches = IrcTools::MessageTypes::RESTART_MATCHER.match message
    assert_message_matches message_matches, :type => 'RESTART'

    # SUMMON
    message = 'SUMMON jto'
    message_matches = IrcTools::MessageTypes::SUMMON_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'jto'

    message = 'SUMMON jto tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::SUMMON_MATCHER.match message
    assert_message_matches message_matches, :recipient => 'jto', :target => 'tolsun.oulu.fi'
  
    # USERS
    message = 'USERS eff.org'
    message_matches = IrcTools::MessageTypes::USERS_MATCHER.match message
    assert_message_matches message_matches, :target => 'eff.org'

    message = ':John USERS tolsun.oulu.fi'
    message_matches = IrcTools::MessageTypes::USERS_MATCHER.match message
    assert_message_matches message_matches, :user => 'John', :target => 'tolsun.oulu.fi'
  
    # WALLOPS
    message = ":csd.bu.edu WALLOPS :Connect '*.uiuc.edu 6667' from Joshua"
    message_matches = IrcTools::MessageTypes::WALLOPS_MATCHER.match message
    assert_message_matches message_matches, :user => 'csd.bu.edu', :message => "Connect '*.uiuc.edu 6667' from Joshua"

    # USERHOST
    message = 'USERHOST Wiz'
    message_matches = IrcTools::MessageTypes::USERHOST_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'Wiz'

    message = 'USERHOST Wiz Michael Marty p'
    message_matches = IrcTools::MessageTypes::USERHOST_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'Wiz Michael Marty p'
  
    # ISON
    message = 'ISON phone'
    message_matches = IrcTools::MessageTypes::ISON_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'phone'

    message = 'ISON phone trillian WiZ jarlek Avalon Angel Monstah'
    message_matches = IrcTools::MessageTypes::ISON_MATCHER.match message
    assert_message_matches message_matches, :nickname => 'phone trillian WiZ jarlek Avalon Angel Monstah'
  end

  private

  def assert_message_matches(matches, contents = {})
    contents.each { |k,v| assert_equal v, matches[k] }
  end
end