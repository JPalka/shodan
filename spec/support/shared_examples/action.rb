# frozen_string_literal: true

RSpec.shared_examples 'action' do
  let(:client) { double }
  let(:browser) { double }
  let(:subject) { described_class.new(client) }
  describe '#execute' do
    context 'command succeeds' do
      before do
        allow(client).to receive(:worlds_global).and_return(input)
        allow(client).to receive(:browser).and_return(browser)
        allow(browser).to receive(:load_page)
        allow(browser).to receive(:extract).and_return(input)
      end

      it { expect(subject.execute).to eq(expected_output) }
    end

    # context 'command fails' do
    #   before do
    #     allow(client).to receive(:worlds_global).and_raise(Exception)
    #     allow(client).to receive(:browser).and_raise(Exception)
    #   end

    #   it { expect { subject.execute }.to raise_error(StandardError) }
    # end
  end
end
