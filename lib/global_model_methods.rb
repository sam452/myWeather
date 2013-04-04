module GlobalModelMethods
  extend ActiveSupport::Concern

  attr_accessor :failure_reason

  module ClassMethods
    def config
      InfoboardAdmin::Application.config
    end

    def loginfo(obj)
      #Rails.logger.info "INFO: #{obj}"
      puts "#{caller.first.split('/').last} INFO: #{obj}"
    end

    def logerr(obj)
      #Rails.logger.info "ERROR: #{obj}"
      puts "#{caller.first.split('/').last} ERROR: #{obj}"
    end

    #returns a ActiveSupport::Notifications::Fanout::Subscriber instance. Pass to remove_event_listener.
    def add_event_listener(event_name, callback_method)
      loginfo "Adding event listener #{callback_method} for event #{event_name}"
      ActiveSupport::Notifications.subscribe(event_name) do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        if callback_method
          loginfo "Heard event #{event.name}. Calling #{callback_method}"
          callback_method.call(event)
        else
          logerr "callback_method for event #{event.name} is nil!"
        end
      end
    end

    def remove_event_listener(listener)
      loginfo "Removing event listener #{listener}"
      ActiveSupport::Notifications.unsubscribe(listener)
    end

    def dispatch_event(event_name, payload=nil)
      loginfo "dispatching_event: Dispatching event #{event_name} with payload #{payload}"
      ActiveSupport::Notifications.instrument(event_name, payload)
    end

    def get_pulse_result_item_as_obj(json_hash)
      begin
        OpenStruct.new(json_hash[json_hash.keys.first.to_s])
      rescue Exception=>e
        logerr "Caught exception: #{e.inspect}"
      end
    end

  end

  included do
    include ClassMethods #makes class methods also act as instance methods.
  end
end