# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  describe "attributes" do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:email) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:provider_uid) }
    it { is_expected.to validate_presence_of(:provider_email) }
    it { is_expected.to validate_presence_of(:role) }

    it { is_expected.to validate_uniqueness_of(:token) }
    it { is_expected.to validate_uniqueness_of(:provider_uid).scoped_to(:provider) }
    it { is_expected.to validate_uniqueness_of(:provider_email).scoped_to(:provider) }
  end

  describe "instance methods" do
    describe "#manager?" do
      it "returns true if the user is an manager" do
        user.role = described_class.roles["Manager"]
        expect(user).to be_manager
      end

      it "returns false if the user is not an manager" do
        user.role = described_class.roles["User"]
        expect(user).not_to be_manager
      end
    end

    describe "#user?" do
      it "returns true if the user is a user" do
        user.role = described_class.roles["User"]
        expect(user).to be_user
      end

      it "returns false if the user is not a user" do
        user.role = described_class.roles["Manager"]
        expect(user).not_to be_user
      end
    end
  end
end
