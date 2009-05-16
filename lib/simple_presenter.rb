class SimplePresenter < BlankSlate
  attr_reader :presentable, :renderer
  alias_method :controller, :renderer

  def initialize(presentable, renderer)
    @presentable = presentable
    @renderer = renderer
  end

  def inspect
    "#<#{self.class}: presenter is a #{@presentable.class}, renderer is a #{@renderer.class}>"
  end

  def method_missing(sym, *args)
    return @presentable.send(sym, *args)  if @presentable.respond_to?(sym)
    return @renderer.send(sym, *args)     if @renderer.respond_to?(sym)
    raise NoMethodError, "#{self.class} could not find method `#{sym}`"
  end
end

[:methods, :class].each do |sym|
  SimplePresenter.reveal(sym)
end

module SimplePresenter::Helper
  def present(presentable)
    @presenter_name = "#{presentable.class}Presenter"
    if presentable.is_a?(Array) && (presentable.map{|n| n.class }.uniq.size == 1)
      @array_presenter_name = "#{presentable.first.class}ArrayPresenter"
    end

    if @array_presenter_name && Object.const_defined?(@array_presenter_name)
      presenter = Object.const_get(@array_presenter_name)
    elsif @presenter_name && Object.const_defined?(@presenter_name)
      presenter = Object.const_get(@presenter_name)
    else
      presenter = SimplePresenter
    end

    presenter.new(presentable, self)
  end
end

require 'presenters/array_presenter'