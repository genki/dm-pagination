class Post
  include DataMapper::Resource

  property :id, Serial
  property :index, Integer
end
