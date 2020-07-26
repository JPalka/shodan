# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetPlayerInfo do
  let(:input) do
    { 'result' => { 'name' => 'Korenchkin', 'player_id' => '11524178' } }
  end
  let(:expected_output) do
    { 'name' => 'Korenchkin', 'player_id' => '11524178' }
  end

  include_examples 'action'
end
