# frozen_string_literal: true

require "rails_helper"

RSpec.describe Log do
  subject { build(:log) }

  describe "associations" do
    it { is_expected.to belong_to(:request) }
  end
end
