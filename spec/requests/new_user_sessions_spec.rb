# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'NewUserSessions', type: :request do
  describe 'GET /users/sign_in' do
    it 'works! (now write some real specs)' do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end
end
