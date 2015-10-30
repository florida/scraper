module Scraper
  module Logging
    def logger
      create_log_file unless @logger
      @logger ||= Logger.new(output_destination)
      @logger.level = Logger::INFO
      @logger
    end

    def create_log_file
      Dir.mkdir('log') if !File.directory?('log') && ENV['ENVIRONMENT'] === 'test'
    end

    protected

    def output_destination
      ENV['ENVIRONMENT'] === 'test' ? 'log/test.log' : STDOUT
    end
  end
end
