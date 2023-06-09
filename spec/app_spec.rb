# spec/app_spec.rb
require 'rack/test'
require 'json'
require_relative '../app'

RSpec.describe MyApp do
  include Rack::Test::Methods

  def app
    MyApp.new
  end

  describe 'GET /' do
    it 'returns index.html content' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.header['Content-Type']).to eq('text/html')
      expect(last_response.body).to include('Hello Frontend')
    end
  end

  describe 'GET /hello' do
    it 'returns JSON message' do
      get '/hello'
      expect(last_response).to be_ok
      expect(last_response.header['Content-Type']).to eq('application/json')
      expect(JSON.parse(last_response.body)).to eq({ 'message' => 'Hello, World!' })
    end
  end

  describe 'GET unknown path' do
    it 'returns 404 Not Found' do
      get '/unknown'
      expect(last_response.status).to eq(404)
      expect(last_response.header['Content-Type']).to eq('text/plain')
      expect(last_response.body).to eq('Not Found')
    end
  end
end
