require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data 
  let(:user) { create(:user) }
  let!(:todos) { create_list(:todo, 10, created_by: user.id) }
  let(:todo_id) { todos.first.id }
  # Authorize request
  let(:headers) { valid_headers }

  # Test suite for GET /todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos', params: {}, headers: headers }

    it 'returns todos' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      let(:todo_id) { 117 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end
  
  # Test syute for POST /todos
  describe 'POST /todos' do
    # valid payload
    let(:valid_attributes) do
      { 
        title: "Learn Elmo",
        created_by: 'Kiko'
      }.to_json
    end

    context 'when the request is valid' do
      before do
        post '/todos',
        params: valid_attributes,
        headers: headers
      end

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Elmo')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) do
        {
          title:nil
      }.to_json
      end

      before { post '/todos', params: invalid_attributes, headers: headers }
    
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: "Swimming" }.to_json }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end