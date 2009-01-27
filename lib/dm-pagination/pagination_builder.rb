module DmPagination
  class PaginationBuilder
    def initialize(context, pagination, *args, &block)
      @context = context
      @pagination = pagination
      @block = block
      @options = args.last.kind_of?(Hash) ? args.pop : {}
      @options[:page] ||= :page
      @args = args.blank? ? [:prev, :pages, :next] : args
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
      if @pagination.page > 1
        @context.link_to prev_label,
          url(@options[:page] => @pagination.page - 1),
          :class => :prev, :rel => "prev"
      else
        span.call(prev_label, :prev)
      end
    end

    def link_to_next
      if @pagination.page < @pagination.num_pages
        @context.link_to next_label,
          url(@options[:page] => @pagination.page + 1),
          :class => :next, :rel => "next"
      else
        span.call(next_label, :next)
      end
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
        @context.tag(:span, args[0].to_s,
          :class => [args[1], "disabled"].compact.join(' '))
      end
    end

    def link(page, *args)
      if @block
        @block.call(page, *args)
      else
        @context.link_to(page, url(@options[:page] => page))
      end
    end

    def truncate
      @options[:truncate] || Merb::Plugins.config[:dm_pagination][:truncate]
    end

    def prev_label
      @options[:prev] || Merb::Plugins.config[:dm_pagination][:prev_label]
    end

    def next_label
      @options[:next] || Merb::Plugins.config[:dm_pagination][:next_label]
    end

    def url(params)
      @context.url(@context.params.merge(params))
    end
  end
end
