require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'connection_pool'
require File.dirname(__FILE__) + '/testconfig'
require_relative 'testconfig'
require 'capybara/cucumber'
require 'process'
require 'oci8'
require 'active_support/all'
require 'selenium-webdriver'

Capybara.run_server = false
#Capybara.javascript_driver = :selenium
Capybara.default_driver = TestConfig["capybara_default_driver"]
Capybara.default_selector = :css
Capybara.default_max_wait_time = TestConfig["default_timeout"]
Capybara.app_host = TestConfig["default_site"]


Before do

 # Capybara.current_session.driver

  Capybara.default_driver == :selenium
  Capybara.register_driver :selenium do |app|
    if TestConfig["default_browser"] == :firefox
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.usedOnWindows10.introURL'] = ''
      Capybara::Selenium::Driver.new(app, :browser => TestConfig["default_browser"],
                                     desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false))
    elsif TestConfig["default_browser"] == :chrome
      caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["--start-maximized"]})
      @browser = Capybara::Selenium::Driver.new(app, {:browser => TestConfig["default_browser"], :desired_capabilities => caps})
    else
      @browser = Capybara::Selenium::Driver.new(app, :browser => TestConfig["default_browser"])
    end
  end
end


After do
  Capybara.current_session.driver.quit
end

#for parallel tests
Capybara.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i

module Helpers
  def without_resynchronize
    page.driver.options[:resynchronize] = false
    yield
    page.driver.options[:resynchronize] = true
  end
end

World(Capybara::DSL, Helpers)

#this is executed at the end
at_exit do
  $test_case_id = nil
end

