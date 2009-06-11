require 'dispatcher'
require 'simple_presenter'

ActionController::Base.send :include, SimplePresenter::Helper
ActionController::Base.helper SimplePresenter::Helper
ActionMailer::Base.send :include, SimplePresenter::Helper

# Reload for every development request, but cache in production
ActiveSupport::Dependencies.load_paths += %W( #{RAILS_ROOT}/app/presenters )
Dispatcher.to_prepare do
  Dir.glob("#{RAILS_ROOT}/app/presenters/*.rb") do |presenter_file|
    ActiveSupport::Dependencies.require_or_load(presenter_file)
  end
end
