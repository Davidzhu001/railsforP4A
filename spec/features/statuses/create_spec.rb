require 'rails_helper'

feature "Creating statuses as user" do

  background do
    @user = create(:user)
    log_in(@user)
  end

  scenario "displays the newly created status on page", :js => true do
    expect(Status.count).to eq(0)
    visit statuses_path
    expect(page).to have_content("New Status")
    click_link "New Status"

    fill_in "status_content", with: "My day was great"
    click_button "Submit"
    expect(page).to have_content("My day was great")
    expect(page).to_not have_field('status_content', with: "My day was great")
    expect(Status.count).to eq(1)
  end

  scenario "displays error when status content is missing", :js => true do
    expect(Status.count).to eq(0)

    visit statuses_path
    click_link "New Status"

    fill_in "status_content", with: ""
    click_button "Submit"

    expect(page).to have_content(/can't be blank/i)
    expect(page).to have_field('status_content', with: "")
    expect(Status.count).to eq(0)
  end

  scenario "displays error when status content is shorter than 2 characters", :js => true do
    expect(Status.count).to eq(0)

    visit statuses_path
    click_link "New Status"

    fill_in "status_content", with: "A"
    click_button "Submit"

    expect(page).to have_content(/is too short/i)
    expect(page).to have_field('status_content', with: "A")
    expect(Status.count).to eq(0)
  end
end
