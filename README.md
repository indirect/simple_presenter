SimplePresenter
===============

So code that generates format-specific representations of data is supposedly a View. In Rails, that code is sometimes inexplicably inserted into the Model, which is supposed to know nothing about formats or presentations of the data they represent.

SimplePresenter is an easy way to get that code out of your model and into a separate (and testable) class. Models with view code in them make Martin Fowler cry. Don't make Martin Fowler cry. Use SimplePresenter.

Usage
=====

In `app/presenter/foo_presenter.rb`:

    class FooPresenter < SimplePresenter::Base
      def to_json
        {:id => id, :name => name}.to_json
      end
    end

In `app/controller/foo_controller.rb`:

    class FooController < ApplicationController
      def show
        @foo = Foo.find(params[:id])
        render :json => present(@foo)
      end
    end



http://github.com/indirect/simple_presenter
Copyright (c) 2009 Andre Arko, released under the MIT license