# frozen_string_literal: true

require "rails_helper"

RSpec.describe Index, type: :model do
  subject { FactoryBot.build(:index) }

  describe "associations" do
    it { should belong_to(:request) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:method) }
    it { should validate_presence_of(:path) }
  end
end
