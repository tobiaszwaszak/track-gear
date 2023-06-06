require "rubygems"
require "sinatra"
require "json"
require "dotenv/load"
require "strava-ruby-client"
require "csv"
require "rack/cors"

use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: [:get, :post, :options]
  end
end

Dotenv.load

Strava::Api.configure do |config|
  config.access_token = ENV["STRAVA_ACCESS_TOKEN"]
end

TOKEN_FILE = "tokens.txt"
DEFAULT_ACTIVITY_TIME = "Ride"
DEFAULT_SPORT_TYPE = "GravelRide"

get "/" do
  send_file File.join("frontend", "index.html")
end

get "/activites" do
  file_path = "bike_data.json"
  file = File.read(file_path)
  data = JSON.parse(file)

  status 200
  content_type "application/json"

  transformed_data = transform_data(data)

  JSON.generate(transformed_data)
end

get "/authorise" do
  client = ::Strava::OAuth::Client.new(
    client_id: ENV["STRAVA_CLIENT_ID"],
    client_secret: ENV["STRAVA_CLIENT_SECRET"]
  )

  redirect_url = client.authorize_url(
    redirect_uri: ENV["STRAVA_REDIRECT_URI"],
    approval_prompt: "force",
    response_type: "code",
    scope: "activity:read_all",
    state: "magic"
  )

  redirect redirect_url
end

get "/callback" do
  client = ::Strava::OAuth::Client.new(
    client_id: ENV["STRAVA_CLIENT_ID"],
    client_secret: ENV["STRAVA_CLIENT_SECRET"]
  )

  response = client.oauth_token(code: params["code"])

  tokens = {
    access_token: response.access_token,
    refresh_token: response.refresh_token
  }.to_json

  File.write(TOKEN_FILE, tokens)

  redirect "/"
end

def retrieve_access_token
  File.read(TOKEN_FILE)
end

def transform_data(data)
  update_tokens
  # sync_activities
  data.map do |bike_data|
    end_date = bike_data["finished_at"] || Date.today
    {
      name: bike_data["name"],
      started_at: bike_data["started_at"],
      distance: calculate_distance(bike_data["started_at"], end_date)
    }
  end
end

def update_tokens
  client = ::Strava::OAuth::Client.new(
    client_id: ENV["STRAVA_CLIENT_ID"],
    client_secret: ENV["STRAVA_CLIENT_SECRET"]
  )
  response = client.oauth_token(
    refresh_token: JSON.parse(retrieve_access_token)["refresh_token"],
    grant_type: "refresh_token"
  )
  tokens = {
    access_token: response.access_token,
    refresh_token: response.refresh_token
  }.to_json

  File.write(TOKEN_FILE, tokens)
end

def sync_activities
  client = Strava::Api::Client.new(access_token: JSON.parse(retrieve_access_token)["access_token"])
  file_path = "data.csv"
  File.delete(file_path) if File.exist?(file_path)
  CSV.open(file_path, "w") do |csv|
    csv << ["Date", "Distance"]

    page = 1
    loop do
      activities = client.athlete_activities({page: page})
      activities.each do |activity|
        next unless activity["type"] == DEFAULT_ACTIVITY_TIME && activity["sport_type"] == DEFAULT_SPORT_TYPE

        csv << [activity["start_date"], activity["distance"]]
      end
      page += 1
      break if activities.empty?
    end
  end
end

def calculate_distance(start_date, end_date)
  total_distance = 0

  CSV.foreach("data.csv", headers: true) do |row|
    start_date = Date.parse(start_date.to_s)
    end_date = Date.parse(end_date.to_s)
    date = Date.parse(row["Date"])
    distance = row["Distance"].to_i

    if date >= start_date && date <= end_date
      total_distance += (distance / 1000)
    end
  end

  total_distance
end
