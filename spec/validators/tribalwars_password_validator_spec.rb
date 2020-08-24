# frozen_string_literal: true

require 'rails_helper'

describe TribalwarsPasswordValidator do
  before do
    stub_const('Validatable', Class.new).class_eval do
      include ActiveModel::Validations
      attr_accessor :password

      validates :password, tribalwars_password: true
    end
  end

  let(:subject) { TribalwarsPasswordValidator.new(attributes: :password) }
  let(:mock) { Validatable.new }

  before(:each) { subject.validate_each(mock, 'password', password) }

  context 'when password is not valid' do
    context 'password too short' do
      let(:password) { 'qwert1' }

      it { expect(mock.errors[:password]).to eq(['Password must be at least 8 characters long']) }
    end

    context 'password does not contain number' do
      let(:password) { Faker::Alphanumeric.alpha(number: 8) }

      it { expect(mock.errors[:password]).to eq(['Password must contain at least 1 digit']) }
    end
  end

  context 'when password is valid' do
    let(:password) { Faker::Alphanumeric.alphanumeric(number: 8, min_numeric: 1) }
    it 'does not have errors' do
      expect(mock.errors.count).to eq(0)
    end
  end
end
