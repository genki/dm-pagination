module DmPagination
  module Paginator
    class Base
      attr_reader :page, :num_pages

      def initialize(collection, options)
        @proxy_collection = collection
        order = options[:order]

        @page = (options[:page] || 1).to_i
        @per_page = (options[:per_page] || 10).to_i
        @num_pages = (@proxy_collection.count + @per_page - 1) / @per_page
        @offset = (@page - 1)*@per_page

        @collection = collection.all(:offset => @offset, :limit => @per_page)
        @collection = @collection.all(:order => order) if order
      end

      def count
        [0, [@proxy_collection.count - @offset, @per_page].min].max
      end

      def respond_to?(*args, &block)
        super || @collection.send(:respond_to?, *args, &block)
      end

      def method_missing(method, *args, &block)
        @collection.send(method, *args, &block)
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), %w(paginator *))].each{|i| require(i)}
