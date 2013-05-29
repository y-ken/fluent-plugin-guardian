module Fluent
  class Fluent::GuardianOutput < Fluent::Output
    Fluent::Plugin.register_output('guardian', self)

    config_param :redis_host, :string, :default => '127.0.0.1'
    config_param :redis_port, :integer, :default => 6379

    def initialize
      super
      require 'redis'
      require 'json'
    end

    def configure(conf)
      super

      @redis_host = conf['redis_host'] || '127.0.0.1'
      @redis_port = conf['redis_port'] || 6379
      @db_number = conf['db_number'] || 0
    end

    def start
      super
      @redis = Redis.new(
        :host => @redis_host, 
        :port => @redis_port,
        :thread_safe => true, 
        :db => @db_number
      )
      @config = JSON.parse(@redis.get("guardian:conf"))
      $log.info "guardian: loading configuration. #{@config}"
    end

    def shutdown
      @redis.quit
    end

    def emit(tag, es, chain)
      es.each {|time, record|
        begin
          $log.info record
        end
      }
    end
  end
end

