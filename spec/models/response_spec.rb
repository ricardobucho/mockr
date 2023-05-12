# frozen_string_literal: true

require "rails_helper"

RSpec.describe Response, type: :model do
  subject { FactoryBot.build(:response) }

  describe "attributes" do
    it { should respond_to(:body) }
  end

  describe "associations" do
    it { should belong_to(:request) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:format) }
    it { should validate_presence_of(:status) }
  end
end
