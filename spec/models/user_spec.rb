# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject { FactoryBot.build(:user) }

  describe "attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
  end

  describe "validations" do
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:provider_uid) }
    it { should validate_presence_of(:provider_email) }
    it { should validate_presence_of(:role) }

    it { should validate_uniqueness_of(:token) }
    it { should validate_uniqueness_of(:provider_uid).scoped_to(:provider) }
    it { should validate_uniqueness_of(:provider_email).scoped_to(:provider) }
  end

  describe "instance methods" do
    describe "#manager?" do
      it "should return true if the user is an manager" do
        subject.role = User.roles["Manager"]
        expect(subject.manager?).to be_truthy
      end

      it "should return false if the user is not an manager" do
        subject.role = User.roles["User"]
        expect(subject.manager?).to be_falsey
      end
    end

    describe "#user?" do
      it "should return true if the user is a user" do
        subject.role = User.roles["User"]
        expect(subject.user?).to be_truthy
      end

      it "should return false if the user is not a user" do
        subject.role = User.roles["Manager"]
        expect(subject.user?).to be_falsey
      end
    end
  end
end
