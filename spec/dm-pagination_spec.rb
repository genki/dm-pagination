require File.dirname(__FILE__) + '/spec_helper'

DataMapper.setup(:default, "sqlite3::memory:")

Post.auto_migrate!

describe "dm-pagination" do
  describe "paginatable" do
    it "should extend DataMapper::Resource" do
      test = Post.new
      test.should_not be_nil
      Post.should be_respond_to(:paginate)
      Post.all.should be_respond_to(:paginate)
    end

    it "should return Pagination object" do
      Post.paginate.should be_kind_of(DmPagination::Pagination)
      Post.all.paginate.should be_kind_of(DmPagination::Pagination)
    end
  end

  describe "pagination" do
    before :all do
      Post.all.destroy!
      101.times{|i| Post.create(:index => i)}
    end

    it "should be specified on 101 test posts" do
      Post.count.should == 101
    end

    it "should have 10 pages" do
      Post.paginate.num_pages.should == 11
      Post.all.paginate.num_pages.should == 11
    end

    it "should be able to calculate num pages on scope" do
      Post.all(:index.gt => 50).count.should == 50
      Post.all(:index.gt => 50).paginate.num_pages.should == 5
      Post.all(:index.gt => 49).paginate.num_pages.should == 6
    end

    it "should act as Collection" do
      Post.paginate(:page => 8).count.should == 10
      Post.paginate(:page => 11).count.should == 1
      Post.paginate(:page => 12).count.should == 0
      Post.paginate(:page => 5, :per_page => 6).count.should == 6
    end
  end

  describe "pagination builder" do
    include Merb::Helpers::Tag

    before :all do
      Post.all.destroy!
      101.times{|i| Post.create(:index => i)}
    end

    it "should be spawn" do
      Post.count.should == 101
      response = request "/pagination_builder/simple"
      response.should have_selector("div.pagination")
      response.should have_selector("ul")
      response.should have_selector("li")
      response.should have_selector("a[rel=next]")
    end
  end
end
