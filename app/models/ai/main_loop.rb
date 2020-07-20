module AI
  class MainLoop
    def initialize(workers)
      @workers = workers
      @logger = Logger.new(STDOUT)
    end

    def start
      @status = 'running'
      @logger.info('Main loop started')
      while @status != 'stopped'
        sleep(1)
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