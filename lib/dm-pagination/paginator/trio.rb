module DmPagination
  module Paginator
    class Trio < Base
      def pages(window = 5, left = 2, right = 2)
        (1..num_pages).inject([]) do |result, i|
          i <= left || (num_pages - i) < right || (i-page).abs < window ?
            result << i : (result.last.nil? ? result : result << nil)
        end
      end
    end
  end
end
