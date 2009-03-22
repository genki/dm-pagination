module DmPagination
  class Pagination
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

    def pages(window = 5, left = 2, right = 2)
      return [] if num_pages <= 1
      (1..num_pages).inject([]) do |result, i|
        i <= left || (num_pages - i) < right || (i-page).abs < window ?
          result << i : (result.last.nil? ? result : result << nil)
      end
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
