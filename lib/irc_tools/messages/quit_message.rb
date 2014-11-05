module IrcTools
  class QuitMessage < Message
    def initialize(options = {})
      super(options.merge(:type => :quit))
    end

    protected

    def build_message
      return_message = 'QUIT'
      return_message << " :#{message}" if message
      return_message
    end
  end
end