# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusUpdateMailer do
  describe '#notify_creator' do
    let(:vacation) { create(:vacation) }
    let(:mail) { described_class.with(new_status: :confirm).notify_creator(vacation) }

    it 'renders the subject' do
      expect(mail.subject).to eq('The vacation status has been changed.')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([vacation.email])
    end

    it 'enqueues a new mailer' do
      params = { params: { new_status: :confirm }, args: [vacation] }

      expect { mail.deliver_later }.to have_enqueued_mail(described_class, :notify_creator).with(params).exactly(:once)
    end
  end
end
