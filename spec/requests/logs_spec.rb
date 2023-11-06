# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs', type: :request do
  let(:user) { create(:user) }
  describe 'GET /logs' do
    before do
      user.confirm
      sign_in user
    end

    it 'works! (now write some real specs)' do
      get logs_path
      expect(response).to redirect_to('http://www.example.com/birth_setting')
    end
  end
end
