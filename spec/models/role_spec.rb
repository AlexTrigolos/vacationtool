# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users).join_table(:users_roles) }
    it { is_expected.to belong_to(:resource).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end
end
