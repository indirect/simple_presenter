class SimplePresenter < BlankSlate
  attr_reader :presentable, :renderer
  alias_method :controller, :renderer

  def initialize(presentable, renderer)
    raise ArgumentError, "you have to present something" unless presentable
    raise ArgumentError, "you have to have a renderer" unless renderer
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

  def self.namespaced_constant(name)
    return nil unless name
    name.split("::").inject(Object) do |l,r|
      begin
        l.const_get(r)
      rescue
        return nil
      end
    end
  end

  module Helper
    def present(presentable)
      presenter_name = "#{presentable.class}Presenter"
      if presentable.is_a?(Array) && (presentable.map{|n| n.class }.uniq.size == 1)
        array_presenter_name = "#{presentable.first.class}ArrayPresenter"
      else
        array_presenter_name = nil
      end

      presenter = ( SimplePresenter.namespaced_constant(array_presenter_name) ||
        SimplePresenter.namespaced_constant(presenter_name) || SimplePresenter )

      presenter.new(presentable, self)
    end
  end
end

[:methods, :class].each do |sym|
  SimplePresenter.reveal(sym)
end

require 'presenters/array_presenter'