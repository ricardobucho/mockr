# frozen_string_literal: true

require "rails_helper"

RSpec.describe Client do
  subject { build(:client) }

  describe "associations" do
    it { is_expected.to have_many(:requests).dependent(:destroy) }
    it { is_expected.to have_many(:responses).through(:requests) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
