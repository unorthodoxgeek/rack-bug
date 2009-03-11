require "rubygems"

unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require "rack/bug/toolbar"
require "rack/bug/app"
require "rack/bug/panels/timer_panel"
require "rack/bug/panels/env_panel"
require "rack/bug/panels/sql_panel"
require "rack/bug/panels/log_panel"
require "rack/bug/panels/templates_panel"
require "rack/bug/panels/cache_panel"
require "rack/bug/panels/rails_info_panel"
require "rack/bug/panels/active_record_panel"
require "rack/bug/panels/memory_panel"

module Rack
  module Bug
    
    VERSION = "0.1.0"
    
    def self.root
      Pathname.new(::File.dirname(__FILE__) + "/bug").expand_path
    end
    
    class Middleware
      
      def initialize(app)
        @app = app
      end
    
      def call(env)
        # toolbar = Toolbar.new(asset_server)
        # toolbar.call(env)
        cascade.call(env)
      end
      
      def cascade
        Rack::Cascade.new([Rack::Bug::App.new, Toolbar.new(asset_server)])
      end
      
      def asset_server
        Rack::Static.new(@app, :urls => ["/__rack_bug__"], :root => public_path)
      end
      
      def public_path
        ::File.expand_path(::File.dirname(__FILE__) + "/bug/public")
      end
      
    end
    
  end
end