require 'dm-pagination/pagination'

module DmPagination
  module Paginatable
    def paginate(options = {})
      Pagination.new(all, options)
    end
  end
end
