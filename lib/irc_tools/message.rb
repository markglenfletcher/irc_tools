module IrcTools
  require 'ostruct'

  class Message < OpenStruct
    attr_reader :validator

    def self.parse(raw_message)
      if matches = validate_message(raw_message)
        attributes = Hash[matches.names.map { |name| [name.to_sym, matches[name.to_sym]] }]
        return attributes.merge(:type => matches[:type].downcase.to_sym, :raw_message => raw_message)
      else
        return {:type => :unknown, :raw_message => raw_message}
      end
    end

    def self.message_matches(message_regexp, message)
      matcher_type = Object.const_get("IrcTools::MessageTypes::#{message_regexp}")
      matcher_type.match message
    end

    def self.validate_message(message)
      MessageTypes.constants.map do |message_regexp|
      Message.message_matches(message_regexp, message)
      end.compact.first
    end

    def initialize(options = {})
      @validator = MessageTypes::GENERIC_IRC_MESSAGE_MATCHER
      options = Message.parse(options) if options.is_a?(String)
      super(options)
    end

    def method_symbol
      "on_#{type.downcase.to_s}_messages"
    end

    def to_s
      new_message = build_message    
      validator =~ new_message ? new_message : nil
    end

    protected

    def build_message
      new_message = ""
      new_message << ":#{user} " if user
      new_message << "#{type.to_s} "
      new_message << "#{recipient} " if recipient
      new_message << "#{message}" if message
      new_message 
    end
  end
end

require_relative 'messages/pass_message'
require_relative 'messages/nick_message'
require_relative 'messages/user_message'
require_relative 'messages/join_message'
require_relative 'messages/pong_message'
require_relative 'messages/privmsg_message'
require_relative 'messages/quit_message'

