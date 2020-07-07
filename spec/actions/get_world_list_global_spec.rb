# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetWorldListGlobal do
  let(:input) do
    { 'en107' => 'https://en107.tribalwars.net',
      'en110' => 'https://en110.tribalwars.net',
      'en111' => 'https://en111.tribalwars.net',
      'en112' => 'https://en112.tribalwars.net',
      'en113' => 'https://en113.tribalwars.net',
      'en114' => 'https://en114.tribalwars.net',
      'enc1' => 'https://enc1.tribalwars.net',
      'enc2' => 'https://enc2.tribalwars.net',
      'enc3' => 'https://enc3.tribalwars.net',
      'enp6' => 'https://enp6.tribalwars.net',
      'enp7' => 'https://enp7.tribalwars.net',
      'enp8' => 'https://enp8.tribalwars.net',
      'enp9' => 'https://enp9.tribalwars.net' }
  end
  let(:expected_output) { input }
  include_examples 'action'
end
