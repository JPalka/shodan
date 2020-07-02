require 'rails_helper'

RSpec.describe GetUnitConfig do
  let(:client) { double }
  let(:browser) { double }
  let(:subject) { described_class.new(client) }
  let(:unit_config) do
    {:config=>
      {"xmlns"=>"",
       "spear"=>
        {"build_time"=>"291.4285714",
         "pop"=>"1",
         "speed"=>"9.0225563920629",
         "attack"=>"10",
         "defense"=>"15",
         "defense_cavalry"=>"45",
         "defense_archer"=>"20",
         "carry"=>"25"},
       "sword"=>
        {"build_time"=>"428.5714286",
         "pop"=>"1",
         "speed"=>"11.027568924959",
         "attack"=>"25",
         "defense"=>"50",
         "defense_cavalry"=>"25",
         "defense_archer"=>"40",
         "carry"=>"15"},
       "axe"=>
        {"build_time"=>"377.1428571",
         "pop"=>"1",
         "speed"=>"9.0225563920629",
         "attack"=>"40",
         "defense"=>"10",
         "defense_cavalry"=>"5",
         "defense_archer"=>"10",
         "carry"=>"10"},
       "spy"=>
        {"build_time"=>"257.1428571",
         "pop"=>"2",
         "speed"=>"4.5112781960314",
         "attack"=>"0",
         "defense"=>"2",
         "defense_cavalry"=>"1",
         "defense_archer"=>"2",
         "carry"=>"0"},
       "light"=>
        {"build_time"=>"514.2857143",
         "pop"=>"4",
         "speed"=>"5.0125313283208",
         "attack"=>"130",
         "defense"=>"30",
         "defense_cavalry"=>"40",
         "defense_archer"=>"30",
         "carry"=>"80"},
       "heavy"=>
        {"build_time"=>"1028.571429",
         "pop"=>"6",
         "speed"=>"5.5137844606554",
         "attack"=>"150",
         "defense"=>"200",
         "defense_cavalry"=>"80",
         "defense_archer"=>"180",
         "carry"=>"50"},
       "ram"=>
        {"build_time"=>"1371.428571",
         "pop"=>"5",
         "speed"=>"15.037593989485",
         "attack"=>"2",
         "defense"=>"20",
         "defense_cavalry"=>"50",
         "defense_archer"=>"20",
         "carry"=>"0"},
       "catapult"=>
        {"build_time"=>"2057.142857",
         "pop"=>"8",
         "speed"=>"15.037593989485",
         "attack"=>"100",
         "defense"=>"100",
         "defense_cavalry"=>"50",
         "defense_archer"=>"100",
         "carry"=>"0"},
       "knight"=>
        {"build_time"=>"6171.428571",
         "pop"=>"10",
         "speed"=>"5.0125313283208",
         "attack"=>"150",
         "defense"=>"250",
         "defense_cavalry"=>"400",
         "defense_archer"=>"150",
         "carry"=>"100"},
       "snob"=>
        {"build_time"=>"5142.857143",
         "pop"=>"100",
         "speed"=>"17.543859649123",
         "attack"=>"30",
         "defense"=>"100",
         "defense_cavalry"=>"50",
         "defense_archer"=>"100",
         "carry"=>"0"},
       "militia"=>
        {"build_time"=>"1",
         "pop"=>"0",
         "speed"=>"0.016666666666667",
         "attack"=>"0",
         "defense"=>"15",
         "defense_cavalry"=>"45",
         "defense_archer"=>"25",
         "carry"=>"0"}}}
  end

  describe '#execute' do
    context 'command succeeds' do
      before do
        allow(client).to receive(:browser).and_return(browser)
        allow(browser).to receive(:load_page)
        allow(browser).to receive(:extract).and_return(unit_config)
      end 

      it { expect(subject.execute).to eq(unit_config[:config]) }
    end

    context 'command fails' do
      before { allow(client).to receive(:browser).and_raise(Exception) }

      it { expect(subject.execute).to eq(nil) }
    end
  end
end