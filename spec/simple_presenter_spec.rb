require File.dirname(__FILE__) + '/spec_helper'

describe SimplePresenter::Base do
  before(:all) do
    @renderer = Controller.new
    @presentable = String.new
  end

  it "should take a presentable and a renderer when initialized" do
    SimplePresenter::Base.new(@presentable, @renderer)
  end

  it "should store presentable in an attribute" do
    SimplePresenter::Base.new(@presentable, @renderer).presentable.should == @presentable
  end

  it "should store renderer in an attribute" do
    SimplePresenter::Base.new(@presentable, @renderer).renderer.should == @renderer
  end

  it "should track child classes" do
    class NewPresenter < SimplePresenter::Base; end
    SimplePresenter::Base.presenters.should include(NewPresenter)
  end

end

describe SimplePresenter::Helper do
  before(:all) do
    @c = Controller.new
  end

  context "once included" do
    it "should define #present" do
      @c.should respond_to(:present)
    end
  end

  context "present method" do

    context "when given an object with no presenter" do
      it "should return a default presenter" do
        @c.present(Array.new).should be_a(SimplePresenter::Base)
      end
    end

    context "when given an object with a specific presenter" do
      it "should return that specific presenter" do
        @c.present(String.new).should be_a(StringPresenter)
      end
    end

  end
end

describe StringPresenter do
  before(:all) do
    @presenter = Controller.new.present("bob")
  end

  it "should provide its methods via the present() helper" do
    @presenter.ascii_numbers.should == [98, 111, 98]
  end

  it "should pass methods through from the presenter to the presentable" do
    @presenter.ascii_numbers_on_self.should == [98, 111, 98]
  end
end