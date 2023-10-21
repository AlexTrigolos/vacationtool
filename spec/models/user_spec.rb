# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:vacations).dependent(:destroy) }
  end

  describe 'scopes' do
    it '.admins' do
      admin = create(:user)
      admin.add_role(:admin)
      expect(described_class.admins).to include(admin)
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }

    context 'when not admin' do
      it '#admin?' do
        expect(user).not_to be_admin
      end
    end

    context 'when admin' do
      it '#admin?' do
        user.add_role(:admin)
        expect(user).to be_admin
      end
    end
  end
end
