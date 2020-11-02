# frozen_string_literal: true

module AI
  class MainLoop
    attr_reader :status

    def initialize(player_processor, logger: Logger.new(STDOUT))
      @player_processor = player_processor
      @logger = logger
      @status = 'stopped'
    end

    def start
      @status = 'running'
      @logger.info('Main loop started')
      while @status != 'stopped'
        @player_processor.process_player_turn
        sleep(5)
        if @status == 'stopping'
          @logger.info('Shutting down main loop')
          initiate_shutdown
        end
      end
      @logger.info('Main loop stopped.')
    end

    def stop
      @status = 'stopping'
      sleep(0.5) until @status == 'stopped'
    end

    private

    def initiate_shutdown
      # DO SOME STUFF ON SHUTDOWN
      @status = 'stopped'
    end
  end
end
