module DmPagination
  module Paginator
    class Solo < Base
      def pages(window = 10, left = 5, right = 4)
        num_of_pages = num_pages
        return [] if num_of_pages <= 1
        right_page = page + right
        if right_page > num_of_pages
          right_page = num_of_pages
        elsif right_page < window
          right_page = window
        end
        left_page = if num_of_pages - right_page < right
          page - (window - (right_page - page + 1))
        else
          page - left
        end
        left_page = 1 if left_page <= 0
        (left_page..right_page)
      end  
    end
  end
end
