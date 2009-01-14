module DmPagination
  class PaginationBuilder
    def initialize(context, pagination, *args, &block)
      @context = context
      @pagination = pagination
      @block = block
      @options = args.last.kind_of?(Hash) ? args.pop : {}
      @args = args.blank? ? [:prev, :pages, :next] : []
    end

    def to_s(*args)
      args = @args if args.blank?
      items = args.map{|i| respond_to?("link_to_#{i}") ?
        send("link_to_#{i}") : []}.flatten
      @context.tag(:div, items.join("\n"), :class => "pagination")
    end

    def link_to_pages
      @pagination.pages.map{|page| link_to_page(page)}
    end

    def link_to_prev
    end

    def link_to_next
    end

    def link_to_page(page)
      if page.nil?
        span.call truncate, @options[:style]
      elsif page == @pagination.page
        span.call page, [@options[:style], 'current'].compact.join(' ')
      else
        span.call link(page), @options[:style]
      end
    end

  private
    def span
      proc do |*args|
        @context.tag(:span, args[0].to_s, :class => (args[1]||"disabled"))
      end
    end

    def link(page, *args)
      if @block
        @block.call(page, *args)
      else
        @context.link_to(page, @context.url(:page => page))
      end
    end

    def truncate
      @options[:truncate] || '...'
    end
  end
end
