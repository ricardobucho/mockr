# frozen_string_literal: true

require "rails_helper"

RSpec.describe Request do
  subject { build(:request) }

  describe "associations" do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_many(:logs).dependent(:destroy) }
    it { is_expected.to have_many(:responses).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:method) }
    it { is_expected.to validate_presence_of(:path) }
  end
end
