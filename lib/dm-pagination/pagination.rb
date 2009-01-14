module DmPagination
  class Pagination < DataMapper::Collection
    def initialize(collection, options)
      @page = options[:page] || 1
      @per_page = options[:per_page] || 10
      @proxy_collection = collection
      query = collection.send :scoped_query,
        :offset => (@page - 1)*@per_page,
        :limit => @per_page
      super(query){|set| repository.read(query, set, true)}
    end

    def page
      @page
    end

    def num_pages
      (@proxy_collection.count + @per_page - 1) / @per_page
    end

    def pages(window = 5, left = 2, right = 2)
      return [] if num_pages <= 1
      (1..num_pages).inject([]) do |result, i|
        i <= left || (num_pages - i) < right || (i-page).abs < window ?
          result << i : (result.last.nil? ? result : result << nil)
      end
    end

    def count
      offset = (@page - 1)*@per_page
      [0, [@proxy_collection.count - offset, @per_page].min].max
    end
  end
end
