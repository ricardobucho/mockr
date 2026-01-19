# frozen_string_literal: true

require "rails_helper"

RSpec.describe Index do
  subject { build(:index) }

  describe "associations" do
    it { is_expected.to belong_to(:request) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:method) }
    it { is_expected.to validate_presence_of(:path) }
  end
end
