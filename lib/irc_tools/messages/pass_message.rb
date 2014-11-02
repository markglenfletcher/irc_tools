module IrcTools
  class PassMessage < Message
    def initialize(options = {})
      raise ArgumentError.new('Required arguments not supplied: (password)') unless options[:password]
      super(options.merge(:type => :pass))
      @validator = MessageTypes::PASS_MATCHER
    end

    protected

    def build_message
      "PASS #{password}"
    end
  end
end
