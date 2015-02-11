require 'rails_helper'

RSpec.describe Status, :type => :model do
  describe "relationships" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:user_id) }
    it { should ensure_length_of(:content).is_at_least 2 }
  end
end
