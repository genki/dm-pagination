require 'dm-pagination/paginator'

module DmPagination
  module Paginatable
    def paginate(options = {})
      paginator_type = options.delete(:paginator) ||
        Agnostic::plugin(:dm_pagination).paginator
      paginator = Paginator.const_get(paginator_type.to_s.camel_case)
      paginator.new(all, options)
    end
  end
end
