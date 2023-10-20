class Vacation < ApplicationRecord
  include AASM

  belongs_to :user

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  scope :created, ->{ where(status: :created) }
  scope :admin_scope, ->{ order(Arel.sql("CASE WHEN status = 'created' THEN 0 ELSE 1 END")) }

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
      transaction do
        StatusUpdateMailer.with(new_status: attributes[:status]).notify_creator(self).deliver_now
        send("#{attributes[:status]}_vacation!")
      end
    else
      update(attributes.except(:status))
    end
  end

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    errors.add(:end_date, "должна быть после даты начала") if end_date < start_date
  end
end
