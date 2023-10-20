# frozen_string_literal: true

module PrepareParamsByUserAccess
  extend ActiveSupport::Concern

  included do
    def prepare_params!(entity_params)
      current_user.admin? ? entity_params.except(:start_date, :end_date) : entity_params.except(:status)
    end
  end
end
