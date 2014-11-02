module IrcTools
  class PongMessage < Message
    def initialize(options = {})
      super(options.merge(:type => :pong))
      @validator = MessageTypes::PONG_MATCHER
    end

    protected

    def build_message
      "PONG :#{server}".strip
    end
  end
end