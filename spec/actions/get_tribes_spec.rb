# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetTribes do
  let(:client) { double }
  let(:browser) { double }
  let(:subject) { described_class.new(client) }
  let(:tribe_list) do
    { tribes: [{ id: 1,
                 name: 'Old+Skool',
                 tag: '.OS.',
                 member_count: 16,
                 village_count: 80,
                 points_top: 428_719,
                 points: 428_719,
                 rank: 33 },
               { id: 2,
                 name: 'Four+Aces',
                 tag: '4A',
                 member_count: 25,
                 village_count: 236,
                 points_top: 1_344_920,
                 points: 1_344_920,
                 rank: 10 },
               { id: 3,
                 name: 'Premium+Points+Only',
                 tag: 'PPO',
                 member_count: 11,
                 village_count: 13,
                 points_top: 40_307,
                 points: 40_307,
                 rank: 33 }] }
  end
  let(:tribe_list_final) do
    [{ external_id: 1,
       name: 'Old+Skool',
       tag: '.OS.',
       points: 428_719,
       rank: 33 },
     { external_id: 2,
       name: 'Four+Aces',
       tag: '4A',
       points: 1_344_920,
       rank: 10 },
     { external_id: 3,
       name: 'Premium+Points+Only',
       tag: 'PPO',
       points: 40_307,
       rank: 33 }]
  end

  describe '#execute' do
    context 'command succeeds' do
      before do
        allow(client).to receive(:browser).and_return(browser)
        allow(browser).to receive(:load_page)
        allow(browser).to receive(:extract).and_return(tribe_list)
      end

      it { expect(subject.execute).to eq(tribe_list_final) }
    end

    context 'command fails' do
      before { allow(client).to receive(:browser).and_raise(Exception) }

      it { expect(subject.execute).to eq(nil) }
    end
  end
end
