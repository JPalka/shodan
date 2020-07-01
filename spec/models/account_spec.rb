require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to belong_to(:master_server) }

  it { is_expected.to validate_presence_of(:login) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:master_server) }
  it { is_expected.to allow_value(nil).for(:premium_points) }
  it { is_expected.to allow_value(101_010).for(:premium_points) }
  it { is_expected.to allow_value(0).for(:premium_points) }
  it { is_expected.not_to allow_value('garbage').for(:premium_points) }
  it { is_expected.not_to allow_value(-100).for(:premium_points) }
  it { is_expected.not_to allow_value(10.7).for(:premium_points) }
end
