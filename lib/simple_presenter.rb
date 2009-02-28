module SimplePresenter
  module Helper
    def present(presentable)
      presenter_name = "#{presentable.class}Presenter"
      if Object.const_defined?(presenter_name)
        Object.const_get(presenter_name).new(presentable, self)
      else
        SimplePresenter::Base.new(presentable, self)
      end
    end
  end

  class Base < BlankSlate
    attr_reader :presentable, :renderer

    def initialize(presentable, renderer)
      @presentable = presentable
      @renderer = renderer
    end

    def is_a_presenter?
      true
    end

    def method_missing(sym, *args)
      @presentable.send(sym, *args)
    end

    def self.inherited(subclass)
      @@presenters ||= []
      @@presenters << subclass
    end

    def self.presenters
      @@presenters
    end
  end

  Base.reveal(:class)
end