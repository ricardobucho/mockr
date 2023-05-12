# frozen_string_literal: true

require "rails_helper"

RSpec.describe Log, type: :model do
  subject { FactoryBot.build(:log) }

  describe "associations" do
    it { should belong_to(:request) }
  end
end
