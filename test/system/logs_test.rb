# frozen_string_literal: true

require 'application_system_test_case'

class LogsTest < ApplicationSystemTestCase
  setup do
    @log = logs(:one)
  end

  test 'visiting the index' do
    visit logs_url
    assert_selector 'h1', text: 'Logs'
  end

  test 'creating a Log' do
    visit logs_url
    click_on '新規作成'

    fill_in 'Body temperature', with: @log.body_temperature
    fill_in 'Date time', with: @log.date_time
    fill_in 'Description', with: @log.description
    fill_in 'Log type', with: @log.log_type
    fill_in 'Milk amount', with: @log.milk_amount
    fill_in 'Stool color', with: @log.stool_color
    check 'Stool little' if @log.stool_little
    click_on 'Create Log'

    assert_text 'Log was successfully created'
    click_on '戻る'
  end

  test 'updating a Log' do
    visit logs_url
    click_on '編集', match: :first

    fill_in 'Body temperature', with: @log.body_temperature
    fill_in 'Date time', with: @log.date_time
    fill_in 'Description', with: @log.description
    fill_in 'Log type', with: @log.log_type
    fill_in 'Milk amount', with: @log.milk_amount
    fill_in 'Stool color', with: @log.stool_color
    check 'Stool little' if @log.stool_little
    click_on 'Update Log'

    assert_text 'Log was successfully updated'
    click_on '戻る'
  end

  test 'destroying a Log' do
    visit logs_url
    click_on '削除', match: :first
    assert_text 'Log was successfully destroyed'
  end
end
