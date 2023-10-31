# frozen_string_literal: true

require 'test_helper'

class NurserySupportControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get nursery_support_index_url
    assert_response :success
  end
end
