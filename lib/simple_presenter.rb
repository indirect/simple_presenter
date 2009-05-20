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
      presenter_options = ["SimplePresenter"]

      if presentable.is_a?(Array)
        presenter_options.unshift("ArrayPresenter")
        classes = presentable.map{|n| n.class }.uniq
        presenter_options.unshift("#{classes.first}ArrayPresenter") if classes.size == 1
      else
        presenter_options.unshift("#{presentable.class}Presenter")
      end

      presenter = presenter_options.map{|o| SimplePresenter.namespaced_constant(o) }.compact.first
      presenter.new(presentable, self)
    end
  end
end

[:methods, :class].each do |sym|
  SimplePresenter.reveal(sym)
end

require 'presenters/array_presenter'