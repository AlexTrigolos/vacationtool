# frozen_string_literal: true

class Vacation < ApplicationRecord
  include AASM

  belongs_to :user

  STATUSES = %i[created confirmed rejected].freeze

  validates :status, inclusion: { in: STATUSES.map(&:to_s) }
  validates :start_date, :status, :end_date, presence: true
  validate :end_date_after_start_date

  scope :admin_scope, -> { order(Arel.sql("CASE WHEN status = 'created' THEN 0 ELSE 1 END")) }

  delegate :email, to: :user

  aasm column: :status do
    state :created, initial: true
    state :confirmed
    state :rejected

    event :confirm_vacation do
      transitions from: :created, to: :confirmed
    end

    event :reject_vacation do
      transitions from: :created, to: :rejected
    end
  end

  private

  def update_vacation(attributes, user)
    if user.admin?
      status = attributes[:status]
      if status.present?
        StatusUpdateMailer.with(new_status: status).notify_creator(self).deliver_later
        send("#{attributes[:status]}_vacation!")
      end
    else
      update(attributes.except(:status))
    end
  end

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, I18n.t('.end_date_after_start_date')) if end_date < start_date
  end
end
