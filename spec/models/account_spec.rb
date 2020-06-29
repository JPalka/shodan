require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to belong_to(:master_server) }

  it { is_expected.to validate_presence_of(:login) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:email) }
end
