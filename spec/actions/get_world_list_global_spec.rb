require 'rails_helper'

RSpec.describe GetWorldListGlobal do
  let(:client) { double() }
  let(:subject) { described_class.new(client) }
  let(:worlds) do
    { "en107"=>"https://en107.tribalwars.net",
      "en110"=>"https://en110.tribalwars.net",
      "en111"=>"https://en111.tribalwars.net",
      "en112"=>"https://en112.tribalwars.net",
      "en113"=>"https://en113.tribalwars.net",
      "en114"=>"https://en114.tribalwars.net",
      "enc1"=>"https://enc1.tribalwars.net",
      "enc2"=>"https://enc2.tribalwars.net",
      "enc3"=>"https://enc3.tribalwars.net",
      "enp6"=>"https://enp6.tribalwars.net",
      "enp7"=>"https://enp7.tribalwars.net",
      "enp8"=>"https://enp8.tribalwars.net",
      "enp9"=>"https://enp9.tribalwars.net" }
  end

  describe '#execute' do
    context 'command succeeds' do
      before { allow(client).to receive(:world_list_global).and_return(worlds) }

      it { expect(subject.execute).to eq(worlds) }
    end

    context 'command fails' do
      before { allow(client).to receive(:world_list_global).and_raise(Exception) }

      it { expect(subject.execute).to eq({ error: 'Failed to download global world list' }) }
    end
  end
end