# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'

# 0 "breasts"
# 1 "milks"
# 2 "urines"
# 3 "stools"
# 4 "body_temperatures"
# 5 "descriptions"

# hash = {}
# File.open('db/baby_log.json') do |j|
#   hash = JSON.load(j)
# end

# hash.each do |type, data_arr|
#   case type
#   when 'breasts'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 0,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0)
#       )
#     end
#   when 'milks'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 1,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0),
#         milk_amount: data['milk_amount'].to_i
#       )
#     end
#   when 'urines'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 2,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0)
#       )
#     end
#   when 'stools'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 3,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0),
#         stool_little: data['stool_little'],
#         stool_color: data['stool_color'].to_i
#       )
#     end
#   when 'body_temperatures'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 4,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0),
#         body_temperature: data['body_temperature_amount'].to_f
#       )
#     end
#   when 'descriptions'
#     data_arr.each do |data|
#       Log.create(
#         log_type: 5,
#         date_time: Time.at(data['recording_time'].to_i / 1000.0),
#         description: data['description_text']
#       )
#     end
#   end
# end

# deviceユーザシード
users = %w[yamada abe tanaka yave kitani]
users.each do |user|
  u = User.create(
    email: "#{user}@example.com",
    password: 'password',
    confirmed_at: DateTime.now
  )
  u.build_setting
  u.save!
end

Log.create!(log_type: 0, date_time: DateTime.now, user_id: User.first.id)
Log.create!(log_type: 1, milk_amount: 150, date_time: DateTime.now, user_id: User.second.id)
