module IrcTools
  class UserMessage < Message
    def initialize(options = {})
      raise ArgumentError.new('Required arguments not supplied: (nickname,mode,realname)') unless options[:nickname] && options [:mode] && options[:realname]
      super(options.merge(:type => :user))
    end

    protected

    def build_message
      "USER #{nickname} #{mode} * :#{realname}"
    end
  end
end