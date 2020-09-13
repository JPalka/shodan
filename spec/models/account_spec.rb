# frozen_string_literal: true

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

  describe '#active_worlds_belong_to_same_server' do
    it 'invalidates record when account and active_worlds not on same server' do
      account = create(:account)
      worlds = create_list(:world, 5)
      account.active_worlds.push(worlds.first)

      account.validate
      expect(account.valid?).to be(false)
      expect(account.errors[:active_worlds]).to eq(['World must belong to the same server as account'])
    end

    it 'is valid when active_worlds belong to same server' do
      master_server = create(:master_server)
      worlds = create(:world, master_server: master_server)
      account = create(:account, master_server: master_server)

      account.validate
      expect(account.valid?).to be(true)
    end
  end
end
