# frozen_string_literal: true

require "rails_helper"

RSpec.describe Client, type: :model do
  subject { FactoryBot.build(:client) }

  describe "associations" do
    it { should have_many(:requests).dependent(:destroy) }
    it { should have_many(:responses).through(:requests) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug) }
  end
end
