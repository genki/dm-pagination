module DmPagination
  class Pagination
    def initialize(collection, options)
      @page = (options[:page] || 1).to_i
      @per_page = (options[:per_page] || 10).to_i
      @proxy_collection = collection
      @collection = collection.all(
        :offset => (@page - 1)*@per_page, :limit => @per_page)
      @num_pages = num_pages
    end

    def page
      @page
    end

    def num_pages
      (@proxy_collection.count + @per_page - 1) / @per_page
    end

    def pages(window = 10, left = 5, right = 4)
      return [] if @num_pages <= 1
      right_page = page + right
      if right_page > @num_pages
        right_page = @num_pages
      elsif right_page < window
        right_page = window
      end
      left_page = if @num_pages - right_page < right
        page - (window - (right_page - page + 1))
      else
        page - left
      end
      left_page = 1 if left_page <= 0
      (left_page..right_page)
    end

    def count
      offset = (@page - 1)*@per_page
      [0, [@proxy_collection.count - offset, @per_page].min].max
    end

    def respond_to?(*args, &block)
      super || @collection.send(:respond_to?, *args, &block)
    end

    def method_missing(method, *args, &block)
      @collection.send(method, *args, &block)
    end
  end
end
