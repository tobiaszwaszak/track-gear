require_relative "app"
require "dotenv"

Dotenv.load(".env.development") if ENV["RACKUP_ENV"] == "development"
Dotenv.load(".env.test") if ENV["RACKUP_ENV"] == "test"

run MyApp.new
