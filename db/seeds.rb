# frozen_string_literal: true

faker_date = Faker::Date

User.create(email: 'admin@pochta.org', password: '123456').add_role(:admin)
User.create(email: 'first@mail.ru', password: '123456')
User.create(email: 'second@mail.ru', password: '123456')

user_scope = User.where.not(id: User.admins.pluck(:id))

5.times do
  start_date = faker_date.between(from: Date.current, to: '2028-10-20')
  end_date = faker_date.between(from: start_date, to: '2028-10-21')
  user_id = user_scope.sample.id
  Vacation.create(start_date:, end_date:, status: %w[created confirmed rejected].sample, user_id:)
end
