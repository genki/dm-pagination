$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'spec'
require 'merb-core'
require 'merb-helpers'
require 'merb-assets'
require 'dm-core'
require 'dm-pagination'
require 'dm-pagination/paginatable'
require 'dm-pagination/pagination_builder'
require 'dm-aggregates'

default_options = {
  :environment => 'test',
  :adapter     => 'runner',
  :merb_root   => File.dirname(__FILE__) / 'fixture',
  :log_file    => File.dirname(__FILE__) / '..' / 'log' / "merb_test.log"
}
options = default_options.merge($START_OPTIONS || {})
DataMapper::Model.append_extensions DmPagination::Paginatable
module Merb
  module GlobalHelpers
    def paginate(pagination, *args, &block)
      DmPagination::PaginationBuilder.new(self, pagination, *args, &block)
    end
  end
end

Merb.disable(:initfile)
Merb.start_environment(options)

Spec::Runner.configure do |config|
  config.include Merb::Test::RequestHelper
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher
    
  def with_level(level)
    Merb.logger = Merb::Logger.new(StringIO.new, level)
    yield
    Merb.logger
  end
end
