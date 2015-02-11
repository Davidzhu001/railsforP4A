require 'rails_helper'

feature "Logging in" do

  background do
    @user = create(:user)
  end

  scenario "logs the user in and redirects to the statuses page" do
    visit login_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password

    click_button 'Log in'

    expect(page).to have_content('All Statuses')
    expect(page).to have_content('Logged in successfully.')
  end

  scenario "displays email address when login failed" do
    visit login_path

    fill_in "Email", with: @user.email
    fill_in "Password", with: 'wrongpassword'

    click_button 'Log in'

    expect(page).to have_content('Invalid email or password.')
    expect(page).to have_field('Email', with: @user.email)
  end

end
