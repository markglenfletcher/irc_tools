module IrcTools
  class JoinMessage < Message
    def initialize(options = {})
      raise ArgumentError.new('Required arguments not supplied: (channel)') unless options[:channel]
      super(options.merge(:type => :join))
    end

    protected

    def build_message
      "JOIN #{channel} #{key}".strip
    end
  end
end