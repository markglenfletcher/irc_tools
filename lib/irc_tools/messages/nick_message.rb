module IrcTools
  class NickMessage < Message
    def initialize(options = {})
      raise ArgumentError.new('Required arguments not supplied: (nickname)') unless options[:nickname]
      super(options.merge(:type => :nick))
      @validator = MessageTypes::NICK_MATCHER
    end

    protected

    def build_message
      message = ""
      message << ":#{user} " if user
      message << "NICK #{nickname}"
    end
  end
end