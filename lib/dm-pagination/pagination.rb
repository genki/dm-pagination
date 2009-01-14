module DmPagination
  class Pagination
    def initialize(collection, options)
      @collection = collection
      @page = options[:page] || 1
      @per_page = options[:per_page] || 10
    end

    def page
      @page
    end

    def num_pages
      (@collection.count + @per_page - 1) / @per_page
    end

    def pages(window = 5, left = 2, right = 2)
      return [] if num_pages <= 1
      (1..num_pages).inject([]) do |result, i|
        i <= left || (num_pages - i) < right || (i-page).abs < window ?
          result << i : (result.last.nil? ? result : result << nil)
      end
    end
  end
end
