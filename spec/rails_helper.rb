# spec/rails_helper.rb

# Configure Rails Environment
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../config/environment", __dir__)

# Load the support files
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Set up RSpec
require 'rspec/rails'
require 'pry'
require 'action_controller'

# Additional RSpec configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
