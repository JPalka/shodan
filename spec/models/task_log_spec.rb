# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLog, type: :model do
  subject { create(:task_log) }

  it { is_expected.to belong_to(:account) }
  it { is_expected.to validate_presence_of(:worker_id) }
  it { is_expected.to validate_presence_of(:task_class) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to serialize(:args) }
end
