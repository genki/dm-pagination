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
      Post.paginate.should be_kind_of(DmPagination::Paginator::Base)
      Post.all.paginate.should be_kind_of(DmPagination::Paginator::Base)
    end

    it "should respond to model's method" do
      Post.paginate.should be_respond_to(:to_atom)
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

    it "should handle :order parametetr" do
      Post.paginate(:page => 1, :order => [:id.desc]).first.id.should == 101
    end
  end

  describe "pagination builder" do
    include Merb::Helpers::Tag

    before :all do
      Post.all.destroy!
      101.times{|i| Post.create(:index => i)}
    end

    it "should be tested on 101 posts" do
      Post.count.should == 101
    end

    it "should have rendered with pagination" do
      response = request "/pagination_builder/simple"
      response.should be_successful
      response.should have_selector("div.pagination")
      response.should have_selector("ul")
      response.should have_selector("li")
      response.should have_selector("a[rel=next]")
    end

    it "should have rendered with pagination at page 2" do
      response = request "/pagination_builder/simple", :params => {:page => 2}
      response.should be_successful
      response.should have_selector("a.prev[rel=prev]")
      response.should have_selector("a.next[rel=next]")
      response.body.scan(/Prev|Next/).should == %w(Prev Next)
      url = "/pagination_builder/simple?page=3"
      response.should have_xpath("//a[@href='#{url}']")
    end

    it "should be able to control links" do
      response = request "/pagination_builder/variant"
      response.should be_successful
      response.body.scan(/Prev|Next/).should == %w(Next Prev)
      response.should have_selector("a.next[rel=next]")
      response.should_not have_selector("a.prev[rel=prev]")
      response.should have_selector("span.prev")
      response.should have_selector("span.number")
      response.should_not have_selector("span.prev.number")
      url = "/pagination_builder/variant?foo=2"
      response.should have_xpath("//a[@href='#{url}']")
    end

    describe "solo paginator" do
      before :all do
        Merb::Plugins.config[:dm_pagination][:paginator] = :solo
      end

      after :all do
        Merb::Plugins.config[:dm_pagination][:paginator] = :trio
      end

      it "should have rendered with pagination(1, 3, 4, 5, 6, 7, 8, 9, 10) at page 2" do
        pending
        response = request "/pagination_builder/simple", :params => {:page => 2}
        (1..10).reject{|p| p == 2}.each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should have_xpath("//a[@href='#{url}']")
        end
        [2, 11].each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should_not have_xpath("//a[@href='#{url}']")
        end
      end

      it "should have rendered with pagination(1, 2, 3, 4, 6, 7, 8, 9, 10) at page 5" do
        response = request "/pagination_builder/simple", :params => {:page => 5}
        (1..10).reject{|p| p == 5}.each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should have_xpath("//a[@href='#{url}']")
        end
        pending
        [6, 11].each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should_not have_xpath("//a[@href='#{url}']")
        end
      end

      it "should have rendered with pagination(2, 3, 4, 5, 6, 8, 9, 10, 11) at page 7" do
        response = request "/pagination_builder/simple", :params => {:page => 7}
        (2..11).reject{|p| p == 7}.each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should have_xpath("//a[@href='#{url}']")
        end
        pending
        [1, 7].each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should_not have_xpath("//a[@href='#{url}']")
        end
      end

      it "should have rendered with pagination(2, 3, 4, 5, 6, 7, 8, 9, 11) at page 10" do
      pending
        response = request "/pagination_builder/simple", :params => {:page => 10}
        (2..11).reject{|p| p == 10}.each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should have_xpath("//a[@href='#{url}']")
        end
        [1, 10].each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should_not have_xpath("//a[@href='#{url}']")
        end
      end

      it "should have rendered with pagination(2, 3, 4, 5, 6, 7, 8, 9, 10) at page 11" do
        pending
        response = request "/pagination_builder/simple", :params => {:page => 11}
        (2..10).each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should have_xpath("//a[@href='#{url}']")
        end
        [1, 11].each do |page|
          url = "/pagination_builder/simple?page=#{page}"
          response.should_not have_xpath("//a[@href='#{url}']")
        end
      end
    end

    it "should have rendered with pagination 'pagination_builder?page=2'" do
      response = request "/pagination_builder"
      url = "/pagination_builder?page=2"
      response.should have_xpath("//a[@href='#{url}']")
    end
  end

  describe "#to_json" do
    it "returns the json of the collection" do
      pagination = Post.paginate(:page => 1)

      pagination.to_json.should == pagination.instance_variable_get(:@collection).to_json
    end
  end
end
