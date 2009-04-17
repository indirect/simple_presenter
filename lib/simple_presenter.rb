class SimplePresenter < BlankSlate
  attr_reader :presentable, :renderer
  alias_method :controller, :renderer
  
  def initialize(presentable, renderer)
    @presentable = presentable
    @renderer = renderer
  end
  
  def method_missing(sym, *args)
    @presentable.send(sym, *args)
  end
end

module SimplePresenter::Helper
  def present(presentable)
    presenter_name = "#{presentable.class}Presenter"
    if Object.const_defined?(presenter_name)
      Object.const_get(presenter_name).new(presentable, self)
    else
      SimplePresenter.new(presentable, self)
    end
  end
end
