require File.dirname(__FILE__) + '/spec_helper'
require 'dm-core'
require 'dm-pagination/paginatable'

DataMapper.setup(:default, "sqlite3::memory:")

module DataMapper
  module Resource
    module ClassMethods
      include DmPagination::Paginatable
    end
  end
end

class TestPost
  include DataMapper::Resource

  property :id, Serial
end

describe "dm-pagination" do
  describe "pagination" do
    it "should extend DataMapper::Resource" do
      test = TestPost.new
      test.should_not be_nil
      TestPost.should be_respond_to(:paginate)
      TestPost.all.should be_respond_to(:paginate)
    end

    it "should return Pagination object" do
      TestPost.paginate.should be_kind_of(DmPagination::Pagination)
    end
  end
end
