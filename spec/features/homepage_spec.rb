require 'rails_helper'

<<<<<<< HEAD
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
=======
RSpec.feature "Homepage", type: :feature do
  scenario "User visits the homepage" do
    #navigate to root page
    visit "/"
    #verify content on title of page to verify that it is home page of calculator
    expect(page.title).to eq("BloodPressureCalculator")
  end
end

RSpec.feature "Blood Pressure Calculator Page", type: :feature do
  scenario "Verify all elements have rendered correctly" do
    visit "/"

    # Verify labels
    expect(page).to have_content("Systolic (top number)")
    expect(page).to have_content("Diastolic (bottom number)")

    # Verify fields
    expect(page).to have_field("systolic", type: "number")
    expect(page).to have_field("diastolic", type: "number")

    # Verify submit button
    expect(page).to have_button("Calculate")

    #Verify input is possible and check min and max values
    systolic_field = find_field("systolic")
    expect(systolic_field[:min]).to eq("70")
    expect(systolic_field[:max]).to eq("190")
    #check that input is required
    expect(systolic_field[:required]).to eq("required")

    diastolic_field = find_field("diastolic")
    expect(diastolic_field[:min]).to eq("40")
    expect(diastolic_field[:max]).to eq("100")
    #check that input is required
    expect(diastolic_field[:required]).to eq("required")
  end
end
>>>>>>> development
