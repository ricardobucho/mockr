# frozen_string_literal: true

require "rails_helper"

RSpec.describe Response do
  subject { build(:response) }

  describe "attributes" do
    it { is_expected.to respond_to(:body) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:request) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:format) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
