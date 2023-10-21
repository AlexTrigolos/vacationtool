# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacationsController do
  before { sign_in(admin) }

  let(:admin) { create(:admin) }
  let!(:vacation) { create(:vacation) }

  describe 'GET #index' do
    let(:admin) { create(:user) }

    it 'returns http success' do
      get(:index)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get(:show, params: { id: vacation.id })
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    let(:admin) { create(:user) }

    it 'returns http success' do
      get(:new)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get(:edit, params: { id: vacation.id })
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:admin) { create(:user) }

    context 'with valid params' do
      it 'creates a new Vacation' do
        expect { post(:create, params: { vacation: attributes_for(:vacation) }) }.to change(Vacation, :count).by(1)
      end

      it 'redirects to the created vacation' do
        post(:create, params: { vacation: attributes_for(:vacation) })
        expect(response).to redirect_to(Vacation.last)
      end
    end

    context 'with invalid params' do
      it 'returns a success response (i.e. to display the "new" template)' do
        post(:create, params: { vacation: attributes_for(:vacation, start_date: nil) })
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:vacation_params) { attributes_for(:vacation, status: :confirm, start_date: nil) }

    context 'with valid params' do
      before do
        admin.update(roles: [])
        vacation.update(user: admin)
      end

      let(:new_attributes) { { start_date: Time.zone.today + 1.day } }

      it 'updates the requested vacation' do
        put(:update, params: { id: vacation.id, vacation: new_attributes })
        vacation.reload
        expect(vacation.start_date).to eq(new_attributes[:start_date])
      end

      it 'redirects to the vacation' do
        put(:update, params: { id: vacation.id, vacation: new_attributes })
        expect(response).to redirect_to(vacation)
      end
    end

    context 'with invalid params' do
      it 'returns a success response' do
        put(:update, params: { id: vacation.id, vacation: vacation_params })
        expect(response).to have_http_status(:found)
      end
    end

    context 'with invalid params and not possible status' do
      before { vacation_params[:status] = nil }

      it 'returns a :unprocessable entity response' do
        put(:update, params: { id: vacation.id, vacation: vacation_params })
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vacation' do
      expect { delete(:destroy, params: { id: vacation.id }) }.to change(Vacation, :count).by(-1)
    end

    it 'redirects to the vacations list' do
      delete(:destroy, params: { id: vacation.id })
      expect(response).to redirect_to(vacations_url)
    end
  end
end
