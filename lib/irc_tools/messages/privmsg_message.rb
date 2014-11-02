module IrcTools
  class PrivmsgMessage < Message
    def initialize(options = {})
      raise ArgumentError.new('Required arguments not supplied: (recipient,message)') unless options[:recipient] && options[:message]
      super(options.merge(:type => :privmsg))
      validator = MessageTypes::PRIVMSG_MATCHER
    end

    protected

    def build_message
      "PRIVMSG #{recipient} :#{message}"
    end
  end
end