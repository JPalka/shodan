# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GetWorldConfig do
  let(:input) do
    { config:
      {
        'xmlns' => '',
        'speed' => '3.5',
        'unit_speed' => '0.57',
        'moral' => '0',
        'build' => { 'destroy' => '1' },
        'misc' => { 'kill_ranking' => '2', 'tutorial' => '0', 'trade_cancel_time' => '300' },
        'commands' => { 'millis_arrival' => '1', 'command_cancel_time' => '600' },
        'newbie' =>
              { 'days' => '3',
                'ratio_days' => '60',
                'removenewbievillages' => '1',
                'ratio' => '0' },
        'game' =>
              { 'buildtime_formula' => '2',
                'knight' => '3',
                'knight_new_items' => '0',
                'archer' => '0',
                'tech' => '0',
                'farm_limit' => '0',
                'church' => '0',
                'watchtower' => '0',
                'stronghold' => '1',
                'fake_limit' => '0',
                'barbarian_rise' => '0.003',
                'barbarian_shrink' => '1',
                'barbarian_max_points' => '1500',
                'hauls' => '1',
                'hauls_base' => '1000',
                'hauls_max' => '100000',
                'base_production' => '35',
                'event' => '0',
                'suppress_events' => '0' },
        'buildings' =>
              { 'custom_main' => '-1',
                'custom_farm' => '-1',
                'custom_storage' => '-1',
                'custom_place' => '-1',
                'custom_barracks' => '-1',
                'custom_church' => '-1',
                'custom_smith' => '-1',
                'custom_wood' => '-1',
                'custom_stone' => '-1',
                'custom_iron' => '-1',
                'custom_market' => '-1',
                'custom_stable' => '-1',
                'custom_wall' => '-1',
                'custom_garage' => '-1',
                'custom_hide' => '-1',
                'custom_snob' => '-1',
                'custom_statue' => '-1',
                'custom_watchtower' => '-1' },
        'snob' =>
              { 'gold' => '1',
                'cheap_rebuild' => '0',
                'rise' => '2',
                'max_dist' => '150',
                'factor' => '0.5',
                'coin_wood' => '28000',
                'coin_stone' => '30000',
                'coin_iron' => '25000',
                'no_barb_conquer' => '0' },
        'ally' =>
              { 'no_harm' => '0',
                'no_other_support' => '2',
                'allytime_support' => '0',
                'no_leave' => '0',
                'no_join' => '0',
                'limit' => '20',
                'fixed_allies' => '0',
                'points_member_count' => '20',
                'wars_member_requirement' => '5',
                'wars_points_requirement' => '15000',
                'wars_autoaccept_days' => '5',
                'levels' => '1',
                'xp_requirements' => 'v1' },
        'coord' =>
              { 'map_size' => '1000',
                'func' => '4',
                'empty_villages' => '17',
                'bonus_villages' => '5',
                'inner' => '1887',
                'select_start' => '1',
                'village_move_wait' => '-1',
                'noble_restart' => '0',
                'start_villages' => '1' },
        'sitter' => { 'allow' => '1' },
        'sleep' =>
              { 'active' => '0',
                'delay' => '60',
                'min' => '6',
                'max' => '10',
                'min_awake' => '12',
                'max_awake' => '36',
                'warn_time' => '10' },
        'night' =>
              { 'active' => '0',
                'start_hour' => '23',
                'end_hour' => '7',
                'def_factor' => '2',
                'duration' => '14' },
        'win' => { 'check' => '3' }
      } }
  end
  let(:expected_output) { input[:config] }

  include_examples 'action'
end
