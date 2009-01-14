class PaginationBuilder < Merb::Controller
  def simple
    @posts = Post.paginate
    render
  end
end
