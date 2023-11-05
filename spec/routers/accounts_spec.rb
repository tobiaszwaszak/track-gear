require_relative "../spec_helper"

RSpec.describe App::Routers::Accounts do
  include Rack::Test::Methods

  def app
    App::Routers::Accounts.new
  end

  let(:account) { App::Records::Account.create(email: "foo@bar.dev", password: "123456") }

  before do
    ::App::Records::Account.delete_all
  end

  it "creates a new accounts" do
    post "/accounts", {email: "foo@bar.dev", password: "123456"}.to_json

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a accounts with the given id" do
    get "/accounts/#{account.id}"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to include(JSON.parse({id: account.id, email: account.email}.to_json))
  end

  it "updates a accounts with the given id" do
    put "/accounts/#{account.id}", {email: "foofoo@bar.dev", password: "123456"}.to_json

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID #{account.id}")
  end
end
