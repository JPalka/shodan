require 'rails_helper'

RSpec.describe World, type: :model do
  it { is_expected.to belong_to(:master_server) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:master_server) }
  it { is_expected.to validate_presence_of(:link) }

  it { is_expected.to serialize(:world_config) }
  it { is_expected.to serialize(:unit_config) }
  it { is_expected.to serialize(:building_config) }
end
