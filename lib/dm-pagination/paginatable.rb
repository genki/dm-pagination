require 'dm-pagination/pagination'

module DmPagination
  module Paginatable
    def paginate(options = {})
      Pagination.new(options)
    end
  end
end
