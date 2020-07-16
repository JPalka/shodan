require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to belong_to(:master_server) }
  it { is_expected.to have_and_belong_to_many(:active_worlds) }

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

  it { is_expected.to allow_value('qwertyu1').for(:password) }
  it { is_expected.to allow_value('12345678').for(:password) }
  it { is_expected.not_to allow_value('').for(:password) }
  it { is_expected.not_to allow_value('short1').for(:password) }
  it { is_expected.not_to allow_value('no_digits').for(:password) }

  it { is_expected.to allow_value('user').for(:login) }
  it { is_expected.to allow_value('1234').for(:login) }
  it { is_expected.not_to allow_value('usr').for(:login) }
end
