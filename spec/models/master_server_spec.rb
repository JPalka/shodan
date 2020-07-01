require 'rails_helper'

RSpec.describe MasterServer, type: :model do
  it { is_expected.to have_many(:accounts) }
  it { is_expected.to have_many(:worlds) }

  it { is_expected.to validate_presence_of(:link) }
end
