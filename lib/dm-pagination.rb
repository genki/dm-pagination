require "agnostic"

Agnostic.plugin :dm_pagination do
  prev_label '&laquo; Prev'
  next_label 'Next &raquo;'
  truncate '...'
  paginator :trio
end

Agnostic.modify do
  require "dm-pagination/paginatable"
  module DataMapper
    module Resource
      module ClassMethods
        include DmPagination::Paginatable
      end
    end

    class Collection
      include DmPagination::Paginatable
    end
  end
end

Agnostic.helper do
  require 'dm-pagination/pagination_builder'
  def paginate(pagination, *args, &block)
    DmPagination::PaginationBuilder.new(self, pagination, *args, &block)
  end
end
