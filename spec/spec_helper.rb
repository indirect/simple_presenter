require File.join(File.dirname(__FILE__), '../../../../spec/spec_helper.rb')

# unhide the rspec methods so we can test the class
[:should, :should_not, :kind_of?].each do |sym|
  SimplePresenter::Base.reveal(sym)
end

# dummy controller to call #present on
class Controller
  include SimplePresenter::Helper
end

# dummy presenter to test against
class StringPresenter < SimplePresenter::Base
  def ascii_numbers
    # returns an array of the integer number each char in the string represents
    presentable.unpack("c*")
  end

  def ascii_numbers_on_self
    unpack("c*")
  end
end