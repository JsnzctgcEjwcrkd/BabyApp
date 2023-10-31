# frozen_string_literal: true

require 'test_helper'

class LogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @log = logs(:one)
  end

  test 'should get index' do
    get logs_url
    assert_response :success
  end

  test 'should get new' do
    get new_log_url
    assert_response :success
  end

  test 'should create log' do
    assert_difference('Log.count') do
      post logs_url,
           params: { log: { body_temperature: @log.body_temperature,
                            date_time: @log.date_time,
                            description: @log.description,
                            log_type: @log.log_type,
                            milk_amount: @log.milk_amount,
                            stool_color: @log.stool_color,
                            stool_little: @log.stool_little } }
    end

    assert_redirected_to log_url(Log.last)
  end

  test 'should show log' do
    get log_url(@log)
    assert_response :success
  end

  test 'should get edit' do
    get edit_log_url(@log)
    assert_response :success
  end

  test 'should update log' do
    patch log_url(@log),
          params: { log: { body_temperature: @log.body_temperature,
                           date_time: @log.date_time,
                           description: @log.description,
                           log_type: @log.log_type,
                           milk_amount: @log.milk_amount,
                           stool_color: @log.stool_color,
                           stool_little: @log.stool_little } }
    assert_redirected_to log_url(@log)
  end

  test 'should destroy log' do
    assert_difference('Log.count', -1) do
      delete log_url(@log)
    end

    assert_redirected_to logs_url
  end
end
