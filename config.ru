require_relative "app"
require_relative "auth_middleware"

require_relative "multitenancy_middleware"

require "dotenv"

Dotenv.load(".env.development") if ENV["RACK_ENV"] == "development"
Dotenv.load(".env.test") if ENV["RACK_ENV"] == "test"

use AuthMiddleware
use MultitenancyMiddleware
run MyApp.new
