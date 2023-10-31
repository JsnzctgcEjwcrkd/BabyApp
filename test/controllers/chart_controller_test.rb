# frozen_string_literal: true

require 'test_helper'

class ChartControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get chart_index_url
    assert_response :success
  end
end
