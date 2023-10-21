# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vacation do
  let(:user) { create(:user) }
  let(:vacation) { create(:vacation, user:) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Vacation::STATUSES) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'scopes' do
    it '.admin_scope' do
      expect(described_class.admin_scope.to_sql).to include("ORDER BY CASE WHEN status = 'created' THEN 0 ELSE 1 END")
    end
  end

  describe '#end_date_after_start_date' do
    context 'when start_date and end_date are present' do
      before { vacation.update(start_date: Date.current, end_date: Date.tomorrow) }

      it 'does not add an error to end_date' do
        vacation.send(:end_date_after_start_date)
        expect(vacation.errors[:end_date]).to be_empty
      end
    end

    context 'when end_date is before start_date' do
      before { vacation.update(start_date: Date.tomorrow, end_date: Date.current) }

      it 'adds an error to end_date' do
        vacation.send(:end_date_after_start_date)
        expect(vacation.errors[:end_date]).to include('must be after the start date')
      end
    end

    context 'when start_date or end_date is blank' do
      let(:nil_vacation) { build(:vacation, start_date: nil, end_date: nil) }

      it 'does not add an error to end_date' do
        nil_vacation.send(:end_date_after_start_date)
        expect(nil_vacation.errors[:end_date]).to be_empty
      end
    end
  end
end
