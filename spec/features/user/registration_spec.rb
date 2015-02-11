require 'rails_helper'

feature "Registering" do

  scenario "allows the user to register for the site and creates an object in the database" do
    expect(User.count).to eq(0)

    register_user

    expect(User.count).to eq(1)
  end

end
