# frozen_string_literal: true

module AI
  class Log
    include MongoMapper::Document

    key :severity, String
    key :message, String, required: true
    key :origin, String
    key :account, String
    key :world, String
    timestamps!

    def self.write(message)
      Log.create(
        severity: message[:severity],
        message: message[:msg],
        origin: message[:origin],
        account: message[:account],
        world: message[:world]
      )
    end

    def self.close; end

    def self.reopen(_log = nil); end
  end
end
