# frozen_string_literal: true

json.array! @vacations, partial: 'vacations/vacation', as: :vacation
