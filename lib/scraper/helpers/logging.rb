module Scraper
  module Logging
    def logger
      create_log_file unless @logger
      output = ENV['ENVIRONMENT'] === 'test' ? 'log/test.log' : STDOUT
      @logger ||= Logger.new(output)
      @logger.level = Logger::INFO
      @logger
    end

    def create_log_file
      Dir.mkdir('log') if !File.directory?('log') && ENV['ENVIRONMENT'] === 'test'
    end
  end
end
