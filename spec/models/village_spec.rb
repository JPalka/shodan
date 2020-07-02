# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Village', type: :model do
  subject { create(:village) }

  it { is_expected.to belong_to(:world) }
  it { is_expected.to belong_to(:owner) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_numericality_of(:points).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:external_id).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to validate_uniqueness_of(:external_id).scoped_to(:world_id) }

  context 'coordinate validation' do
    before do
      subject.world.world_config = { 'coord' =>
      { 'map_size' => '1000',
        'func' => '4',
        'empty_villages' => '17',
        'bonus_villages' => '5',
        'inner' => '1887',
        'select_start' => '1',
        'village_move_wait' => '-1',
        'noble_restart' => '0',
        'start_villages' => '1' } }
    end
    let(:size) { subject.world.world_config['coord']['map_size'] }
    it {
      is_expected.to validate_numericality_of(:x_coord).only_integer
                                                       .is_greater_than_or_equal_to(0)
                                                       .is_less_than_or_equal_to(size.to_i)
    }
    it {
      is_expected.to validate_numericality_of(:y_coord).only_integer
                                                       .is_greater_than_or_equal_to(0)
                                                       .is_less_than_or_equal_to(size.to_i)
    }
  end
end
