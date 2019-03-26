require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # Creating users
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end

  # User signup test suite
  describe 'POST /signup' do
    # When valid request
    context 'when valid request' do
      before { 
        post '/signup',
        params: valid_attributes.to_json,
        headers: headers
      }

      # Creates a user
      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end
      
      # Returns success message
      it 'returns success message' do
        expect(json['message'])
          .to match(/Account created successfully/)
      end

      # Returns auth token
      it 'returns an auth token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    # Invalid request
    context 'when invalid request' do
      before {
        post '/signup',
        params: {},
        headers: headers
      }

      # does not create user
      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      # Returns failure message
      it 'returns a failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end
end