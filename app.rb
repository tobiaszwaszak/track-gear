require 'rack'
require 'json'

class MyApp
  def call(env)
    req = Rack::Request.new(env)

    case req.path
    when '/'
      status = 200
      headers = { 'content-type' => 'text/html' }
      body = [File.read('frontend/index.html')]
    when '/hello'
      status = 200
      headers = { 'content-type' => 'application/json' }
      body = [{ message: 'Hello, World!' }.to_json]
    else
      status = 404
      headers = { 'content-type' => 'text/plain' }
      body = ['Not Found']
    end

    [status, headers, body]
  end
end
