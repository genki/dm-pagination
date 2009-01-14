class PaginationBuilder < Merb::Controller
  def simple
    @posts = Post.paginate(params)
    render
  end

  def variant
    @posts = Post.paginate(params)
    render
  end
end
