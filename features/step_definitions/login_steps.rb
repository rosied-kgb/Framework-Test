Given(/^I visit the login page$/) do
  visit('/login')
end

When(/^I login with correct credentials$/) do
  expect(page).to have_text('Login Page')
  page.fill_in('Username', :with => TestConfig['username'])
  page.fill_in('Password', :with => TestConfig['password'])
  page.click_button('Login')
end

Then (/^I am logged into the secure area$/) do
  expect(page).to have_text('You logged into a secure area!'), 'Access denied'
end