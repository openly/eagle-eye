require 'rubygems'
gem 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.run_server = false

if ENV['in_browser'] == "yes"
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.default_driver = :selenium
else
  Capybara.default_driver = :poltergeist
end

case ENV['env'] 
	when 'test'
		Capybara.app_host = 'http://clients.openly.co'
	else # local
		Capybara.app_host = 'http://clients.openly.co'
end

World(Capybara)