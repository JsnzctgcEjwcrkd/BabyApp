# frozen_string_literal: true

require 'uuidtools'

class DemoController < ApplicationController
  before_action :authenticate_temporary_user, only: [:show]
  before_action :authenticate_user!, only: []

  def show
    load_custom_seed_data
    session[:demo_user] = true
    session[:display_ago] = 1
    redirect_to logs_url
  end

  private

  def authenticate_temporary_user
    uuid = UUIDTools::UUID.random_create.to_s
    pass = UUIDTools::UUID.random_create.to_s
    @user = User.new(email: "#{client_ip}_#{uuid}@example.com", password: pass, password_confirmation: pass)
    @user.save
    @user.confirm
    sign_in @user
  end

  def load_custom_seed_data
    week_range = 6.days.ago...Time.zone.now
    current_date = week_range.begin
    while current_date <= week_range.end
      date = current_date.to_date
      create_body_temp(date)
      create_milk(date)
      create_breasts(date)
      create_stool(date)
      create_urines(date)
      create_desc_parents_doby_tmp(date)
      current_date += 1.day
    end
    create_high_body_temp(2.days.ago)
    create_desc_wake_sleep(1.days.ago)
    create_desc_wake_sleep_today(Time.zone.now)
    create_desc_meal(Time.zone.now)
    create_desc_note_plan(1.days.ago)
  end

  def client_ip
    request.remote_ip
  end

  def create_body_temp(date)
    specified_time = Time.new(date.year, date.month, date.day, 7, 0, 0)
    random_time = Faker::Time.between(from: specified_time - 15.minutes, to: specified_time + 15.minutes)
    truncated_minutes = (random_time.min / 5) * 5
    insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
    Log.create(
      log_type: 4,
      body_temperature: rand(36.5..37.6).to_d.truncate(1).to_f,
      date_time: insert_date,
      user_id: @user.id
    )
  end

  def create_milk(date)
    6.times do |i|
      dividend = 24 / 6.0
      hour = (i * dividend).to_i
      specified_time = Time.new(date.year, date.month, date.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 1,
        milk_amount: 60,
        date_time: insert_date,
        user_id: @user.id
      )
    end
  end

  def create_breasts(date)
    10.times do |i|
      dividend = 24 / 10.0
      hour = (i * dividend).to_i
      specified_time = Time.new(date.year, date.month, date.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 0,
        date_time: insert_date,
        user_id: @user.id
      )
    end
  end

  def create_stool(date)
    2.times do |i|
      dividend = 24 / 2
      hour = (i * dividend).to_i + 3
      specified_time = Time.new(date.year, date.month, date.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 55.minutes, to: specified_time + 55.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 3,
        stool_little: [true, false].sample,
        stool_color: rand(1..5),
        date_time: insert_date,
        user_id: @user.id
      )
    end
  end

  def create_urines(date)
    6.times do |i|
      dividend = 24 / 6.0
      hour = (i * dividend).to_i + 1
      specified_time = Time.new(date.year, date.month, date.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 2,
        date_time: insert_date,
        user_id: @user.id
      )
    end
  end

  def create_high_body_temp(datetime)
    6.times do |i|
      dividend = 24 / 6.0
      hour = (i * dividend).to_i + 1
      specified_time = Time.new(datetime.year, datetime.month, datetime.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(datetime.year, datetime.month, datetime.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 4,
        body_temperature: rand(37.9..39.6).to_d.truncate(1).to_f,
        date_time: insert_date,
        user_id: @user.id
      )
    end
  end

  def create_desc_parents_doby_tmp(date)
    specified_time = Time.new(date.year, date.month, date.day, 7, 0, 0)
    random_time = Faker::Time.between(from: specified_time - 15.minutes, to: specified_time + 15.minutes)
    truncated_minutes = (random_time.min / 5) * 5
    insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
    Log.create(
      log_type: 5,
      date_time: insert_date,
      tag_list: 'パパママ体温',
      description: "パパ#{rand(36.5..37.6).to_d.truncate(1).to_f}°C ママ#{rand(36.5..37.6).to_d.truncate(1).to_f}°C",
      user_id: @user.id
    )
  end

  def create_desc_wake_sleep(date)
    4.times do |i|
      dividend = 24 / 4.0
      hour = (i * dividend).to_i + 1
      specified_time = Time.new(date.year, date.month, date.day, hour, 0, 0)
      random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
      truncated_minutes = (random_time.min / 5) * 5
      insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
      Log.create(
        log_type: 5,
        date_time: insert_date,
        tag_list: '寝た',
        description: '',
        user_id: @user.id
      )
      Log.create(
        log_type: 5,
        date_time: insert_date + 2.hours + rand(1..59).minutes,
        tag_list: '起きた',
        description: '',
        user_id: @user.id
      )
    end
  end

  def create_desc_wake_sleep_today(date)
    specified_time = Time.new(date.year, date.month, date.day, 0, 6, 0)
    random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
    truncated_minutes = (random_time.min / 5) * 5
    insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
    Log.create(
      log_type: 5,
      date_time: insert_date,
      tag_list: '寝た',
      description: '',
      user_id: @user.id
    )
    Log.create(
      log_type: 5,
      date_time: insert_date + 5.hours + rand(1..59).minutes,
      tag_list: '起きた',
      description: '',
      user_id: @user.id
    )
  end

  def create_desc_meal(date)
    specified_time = Time.new(date.year, date.month, date.day, 8, 0, 0)
    random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
    truncated_minutes = (random_time.min / 5) * 5
    insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
    Log.create(
      log_type: 5,
      date_time: insert_date,
      tag_list: '離乳食',
      description: '十分がゆ、かぼちゃペースト、人参ペースト、ほうれん草ペースト',
      user_id: @user.id
    )
    Log.create(
      log_type: 5,
      date_time: insert_date - rand(1..59).minutes,
      tag_list: 'お白湯',
      description: '50ml',
      user_id: @user.id
    )
  end

  def create_desc_note_plan(date)
    specified_time = Time.new(date.year, date.month, date.day, 19, 0, 0)
    random_time = Faker::Time.between(from: specified_time - 5.minutes, to: specified_time + 15.minutes)
    truncated_minutes = (random_time.min / 5) * 5
    insert_date = Time.new(date.year, date.month, date.day, random_time.hour, truncated_minutes, 0)
    Log.create(
      log_type: 5,
      date_time: insert_date + rand(1..59).minutes,
      tag_list: '連絡帳ネタ',
      description: '日曜日は近所の児童館へ遊びに行きました。ずっと行きたいと願っていてやっとコンビカーに乗れた〇〇はご機嫌でした。偶然にも以前の保育園のお友達とも再開して思い出したようです。寂しい気持ちになってしまったかなと心配したのですが、夕食時は「別の保育園、何て名前だったっけ？」としっかり以前の保育園として認識しているようで安心しました。',
      user_id: @user.id
    )
    Log.create(
      log_type: 5,
      date_time: insert_date,
      tag_list: '連絡帳ネタ',
      description: '今日は降園後、保育園での出来事をたくさんお喋りしてくれました。今週末はいよいよ運動会で本人はとっても張り切っています。※本日予備の長袖を追加しました。',
      user_id: @user.id
    )
    Log.create(
      log_type: 5,
      date_time: insert_date - rand(1..59).minutes,
      tag_list: '保育園メモ',
      description: '来週から水遊びをするので、タオルとサンダルを持参してほしいとのこと。by〇〇先生',
      user_id: @user.id
    )
  end
end
