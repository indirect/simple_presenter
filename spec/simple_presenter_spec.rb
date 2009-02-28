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

end

describe SimplePresenter::Helper do
  context "once included" do
    it "should define #present" do
      Controller.new.should respond_to(:present)
    end
  end

  context "present method" do

    context "when given an object with no presenter" do
      it "should return a default presenter" do
        Controller.new.present({:a => 1}).class.should be(SimplePresenter::Base)
      end
    end

    context "when given an object with a specific presenter" do
      it "should return that specific presenter" do
        Controller.new.present([1,2,3]).class.ancestors.should include(ArrayPresenter)
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