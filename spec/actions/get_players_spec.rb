# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetPlayers do
  let(:input) do
    { players: [{ name: 'wannat8',
                  id: 110_622,
                  tribe_id: 0,
                  village_count: 1,
                  points: 68,
                  rank: 420 },
                { name: 'calaca',
                  id: 173_973,
                  tribe_id: 0,
                  village_count: 1,
                  points: 540,
                  rank: 210 }] }
  end
  let(:expected_output) do
    [{ name: 'wannat8',
       external_id: 110_622,
       tribe_id: 0,
       village_count: 1,
       points: 68,
       rank: 420 },
     { name: 'calaca',
       external_id: 173_973,
       tribe_id: 0,
       village_count: 1,
       points: 540,
       rank: 210 }]
  end

  include_examples 'action'
end
