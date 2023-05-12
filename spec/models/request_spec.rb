# frozen_string_literal: true

require "rails_helper"

RSpec.describe Request, type: :model do
  subject { FactoryBot.build(:request) }

  describe "associations" do
    it { should belong_to(:client) }
    it { should have_many(:logs).dependent(:destroy) }
    it { should have_many(:responses).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:method) }
    it { should validate_presence_of(:path) }
  end
end
