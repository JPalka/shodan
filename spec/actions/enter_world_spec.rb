# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnterWorld do
  let(:client) { double }
  let(:subject) { described_class.new(client) }
  let(:input) do
    { 'result' =>
      { 'sid' =>
        'bc4548bd030e333a0d27aecb9687578b9af01098316042182bc9c1af7c40d5fc988bf4215170fc472c73c1b382cb9d31c89bdd3a25bf46509ecb76b2a5f27dc4',
        'login_url' =>
        'https://en115.tribalwars.net/login.php?token=7a2e6781830b86c42f8e2f944c61ac5581919bec43aea5c1fb131cc96104851b9a1f48303c149f609275188bb4d3445c9ddc9164e4999bfcc5a04f2298eb25ac',
        'menu' =>
        { 'main' => { 'title' => 'Headquarters', 'image' => 'o_hq.png' },
          'train' => { 'title' => 'Recruit', 'image' => 'o_recruit.png' },
          'place' => { 'title' => 'Rally point', 'image' => 'o_place.png' },
          'mail' => { 'title' => 'Mail', 'image' => 'o_mail.png' },
          'report' => { 'title' => 'Reports', 'image' => 'o_reports.png' },
          'ally' => { 'title' => 'Tribe', 'image' => 'o_ally.png' },
          'ally_forum' => { 'title' => 'Tribe forum', 'image' => 'o_ally_forum.png' },
          'incomings' => { 'title' => 'Incomings', 'image' => 'o_attacks.png' },
          'ranking' => { 'title' => 'Ranking', 'image' => 'o_rankings.png' },
          'info_player' => { 'title' => 'Profile', 'image' => 'o_profile.png' },
          'overview_villages' => { 'title' => 'Overviews', 'image' => 'o_overviews.png' },
          'daily_bonus' => { 'title' => 'Daily Bonus', 'image' => 'o_daily_bonus.png' },
          'settings' => { 'title' => 'Settings', 'image' => 'o_settings.png' },
          'inventory' => { 'title' => 'Inventory', 'image' => 'o_inventory.png' },
          'map' => { 'title' => 'Map', 'image' => 'o_map.png' },
          'market' => { 'title' => 'Market', 'image' => 'o_market.png' },
          'premium' => { 'title' => 'Premium', 'image' => 'o_pa.png' },
          'accountmanager' => { 'title' => 'Account Manager', 'image' => 'o_am.png' },
          'am_farm' => { 'title' => 'Loot Assistant', 'image' => 'o_fa.png' },
          'flags' => { 'title' => 'Flags', 'image' => 'o_flags.png' },
          'invite_friends' => { 'title' => 'Invite friends', 'image' => 'o_invite.png' },
          'memo' => { 'title' => 'Notebook', 'image' => 'o_notebook.png' },
          'community_forum' => { 'title' => 'Community Forum', 'image' => 'o_forum.png' },
          'help' => { 'title' => 'Help', 'image' => 'o_help.png' },
          'buddies' => { 'title' => 'Friends', 'image' => 'o_friends.png' },
          'support' => { 'title' => 'Support system', 'image' => 'o_support.png' } },
        'menu_order' =>
        %w[main
           train
           place
           mail
           report
           ally
           ally_forum
           incomings
           ranking
           info_player
           overview_villages
           daily_bonus
           settings
           inventory
           map
           market
           premium
           accountmanager
           am_farm
           flags
           invite_friends
           memo
           community_forum
           help
           buddies
           support],
        'world' =>
        { 'server_name' => 'en115',
          'name' => 'World 115',
          'url' => 'https://en115.tribalwars.net' },
        'sat' => false,
        'sitter_id' => nil,
        'sitter_name' => 'Korenchkin',
        'sleep' => false,
        'ban' => false,
        'tests' => [],
        'node_server' => 'https://en115.tribalwars.net:8082',
        'active_event' => nil,
        'locale' => 'en_DK' } }
  end

  let(:expected_output) { input['result'] }

  describe '#execute' do
    context 'world exists on remote' do
      before do
        allow(client).to receive(:change_world).and_return(true)
        allow(client).to receive(:login_to_world).and_return(input)
      end

      it { expect(subject.execute('en115')).to eq(expected_output) }
    end

    context 'world does not exist on remote' do
      before do
        allow(client).to receive(:change_world).and_return(false)
        allow(client).to receive(:login_to_world).and_return(input)
      end

      it { expect { subject.execute('yolo') }.to raise_error(ArgumentError) }
    end
  end
end
