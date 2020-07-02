require 'rails_helper'

RSpec.describe Player, type: :model do
  subject { create(:player) }
  it { is_expected.to belong_to(:world) }
  it { is_expected.to belong_to(:account).without_validating_presence }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:rank).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:external_id).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_uniqueness_of(:external_id).scoped_to(:world_id) }
end
