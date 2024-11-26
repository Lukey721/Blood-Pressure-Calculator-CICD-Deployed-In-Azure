require 'rails_helper'

RSpec.feature "HomePage", type: :feature do
  before do
    # Register Selenium remote driver
    Capybara.register_driver :selenium_remote do |app|
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV.fetch('SELENIUM_URL', 'http://localhost:4444/wd/hub'),
        capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
          'goog:chromeOptions' => { args: ['headless', 'disable-gpu', 'no-sandbox'] }
        )
      )
    end

    # Set the JavaScript driver for the test
    Capybara.javascript_driver = :selenium_remote
  end
end