class Post
  include DataMapper::Resource

  property :id, Serial
  property :index, Integer

  def self.to_atom
    "atom"
  end
end
