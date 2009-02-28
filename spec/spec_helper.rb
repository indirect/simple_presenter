require File.join(File.dirname(__FILE__), '../../../../spec/spec_helper.rb')

# dummy controller to call #present on
class Controller
  include SimplePresenter::Helper
end

# dummy presenters to test against
class ArrayPresenter < SimplePresenter
end

class StringPresenter < SimplePresenter
  def ascii_numbers
    # returns an array of the integer number each char in the string represents
    presentable.unpack("c*")
  end

  def ascii_numbers_on_self
    # returns the same array but calls unpack on self
    unpack("c*")
  end
end

# unhide some methods so we can test the presentery proxy classes
[:should, :should_not, :instance_of?, :inspect, :class].each do |sym|
  [ArrayPresenter, StringPresenter, SimplePresenter].each{|p| p.reveal(sym) }
end
