require File.dirname(__FILE__) + '/spec_helper'
require 'dm-core'
require 'dm-pagination/paginatable'
require 'dm-aggregates'

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
  property :index, Integer
end

TestPost.auto_migrate!

describe "dm-pagination" do
  describe "paginatable" do
    it "should extend DataMapper::Resource" do
      test = TestPost.new
      test.should_not be_nil
      TestPost.should be_respond_to(:paginate)
      TestPost.all.should be_respond_to(:paginate)
    end

    it "should return Pagination object" do
      TestPost.paginate.should be_kind_of(DmPagination::Pagination)
      TestPost.all.paginate.should be_kind_of(DmPagination::Pagination)
    end
  end

  describe "pagination" do
    before :all do
      TestPost.all.destroy!
      100.times{|i| TestPost.create(:index => i)}
    end

    it "should be specified on 100 test posts" do
      TestPost.count.should == 100
    end

    it "should have 10 pages" do
      TestPost.paginate.num_pages.should == 10
      TestPost.all.paginate.num_pages.should == 10
    end

    it "should be able to calculate num pages on scope" do
      TestPost.all(:index.gt => 50).count.should == 49
      TestPost.all(:index.gt => 50).paginate.num_pages.should == 5
    end
  end
end
