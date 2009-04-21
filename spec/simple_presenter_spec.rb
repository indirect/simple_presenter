require File.dirname(__FILE__) + '/spec_helper'

describe SimplePresenter do
  before(:all) do
    @renderer = Controller.new
    @presentable = String.new
  end

  it "should take a presentable and a renderer when initialized" do
    SimplePresenter.new(@presentable, @renderer)
  end

  it "should store presentable in an attribute" do
    SimplePresenter.new(@presentable, @renderer).presentable.should == @presentable
  end

  it "should store renderer in an attribute" do
    SimplePresenter.new(@presentable, @renderer).renderer.should == @renderer
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
        Controller.new.present({:a => 1}).class.
          ancestors.should include(SimplePresenter)
      end
    end

    context "when given an object with a specific presenter" do
      it "should return that specific presenter" do
        Controller.new.present([1,2,3]).class.
          ancestors.should include(ArrayPresenter)
      end
    end

    context "when called instances of different classes on a single renderer" do
      it "should return specific presenters for each" do
        @c = Controller.new
        @c.present("bob").class.ancestors.should include(StringPresenter)
        @c.present([1,2,3]).class.ancestors.should include(ArrayPresenter)
        @c.present({:a => 1}).class.ancestors.should include(SimplePresenter)
      end
    end

  end
end

describe StringPresenter do
  before(:all) do
    @renderer = Controller.new
    @presenter = @renderer.present("bob")
  end

  it "should provide its methods via the present() helper" do
    @presenter.ascii_numbers.should == [98, 111, 98]
  end

  it "should pass methods through from the presenter to the presentable" do
    @presenter.ascii_numbers_on_self.should == [98, 111, 98]
  end

  it "should fall back on passing methods to the controller" do
    @renderer.should_receive(:some_cool_url)
    @presenter.some_cool_url
  end
end