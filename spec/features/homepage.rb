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

  scenario "Visit home page and check for form elements", js: true do
    # Visit the homepage
    visit ENV.fetch('BASE_URL', 'http://localhost:3000')

    # Check if the page displays the heading
    expect(page).to have_content("Blood Pressure Calculator")

    # Check if the form elements are present
    expect(page).to have_selector("form[action='#{root_path}'][method='post']")
    expect(page).to have_field("systolic", type: "number")
    expect(page).to have_field("diastolic", type: "number")
    expect(page).to have_button("Calculate")
  end
end