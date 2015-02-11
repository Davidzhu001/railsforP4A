require 'rails_helper'

feature "Editing settings" do

  background do
    @user = create(:user)
    log_in(@user)
  end

  scenario "changes user information" do
    visit statuses_path
    click_link "#{@user.name}"
    click_link "Settings"

    fill_in "Name", with: "Ted"
    fill_in "Email", with: "teddie@newmail.com"
    fill_in "Current password", with: "treebook2"
    click_button "Update"

    @user.reload

    expect(@user.name).to eq("Ted")
    expect(@user.email).to eq("teddie@newmail.com")
  end

  scenario "does not change user information without current password" do
    visit statuses_path
    click_link "#{@user.name}"
    click_link "Settings"

    fill_in "Name", with: "Ted"
    fill_in "Email", with: "teddie@newmail.com"
    click_button "Update"

    @user.reload

    expect(@user.name).to_not eq("Ted")
    expect(@user.email).to_not eq("teddie@newmail.com")
  end

  scenario "changes user password" do
    visit statuses_path
    click_link "#{@user.name}"
    click_link "Settings"

    fill_in "Password", with: "mysupersecretpassword123"
    fill_in "Confirm password", with: "mysupersecretpassword123"
    fill_in "Current password", with: "treebook2"
    expect{ click_button "Update"; @user.reload }.to change{ @user.encrypted_password }
  end

  scenario "does not change user password if confirmation is incorrect" do
    visit statuses_path
    click_link "#{@user.name}"
    click_link "Settings"

    fill_in "Password", with: "mysupersecretpassword123"
    fill_in "Confirm password", with: "wrongpassword"
    fill_in "Current password", with: "treebook2"
    expect { click_button "Update"; @user.reload }.to_not change{ @user.encrypted_password }
  end

  scenario "does not change user password if current password is incorrect" do
    visit statuses_path
    click_link "#{@user.name}"
    click_link "Settings"

    fill_in "Password", with: "mysupersecretpassword123"
    fill_in "Confirm password", with: "mysupersecretpassword123"
    fill_in "Current password", with: "wrongtreebook2123"
    expect{ click_button "Update"; @user.reload }.to_not change{ @user.encrypted_password }
  end

end
