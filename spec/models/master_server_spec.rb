# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MasterServer, type: :model do
  it { is_expected.to have_many(:accounts) }
  it { is_expected.to have_many(:worlds) }

  it { is_expected.to validate_presence_of(:link) }

  describe '#download_world_list' do
    let(:client) { double }
    let(:worlds) do
      { 'en107' => 'https://en107.tribalwars.net',
        'en110' => 'https://en110.tribalwars.net',
        'en111' => 'https://en111.tribalwars.net',
        'en112' => 'https://en112.tribalwars.net',
        'en113' => 'https://en113.tribalwars.net' }
    end

    before do
      allow(Tribes::Client).to receive(:new).and_return(client)
      allow(client).to receive(:worlds_global).and_return(worlds)
    end

    context 'master server exists' do
      let(:subject) { create(:master_server) }

      it { expect { subject.download_world_list }.to change { subject.worlds.count }.from(0).to(worlds.count) }
    end
  end
end
