# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'spree/url_helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

# Requires factories defined in spree_core
require 'spree/core/testing_support/factories'

Dir["#{File.dirname(__FILE__)}/factories/**"].each do |f|
  fp =  File.expand_path(f)
  require fp
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Spree::UrlHelpers
end

# valid factory tests
RSpec::Matchers.define :have_valid_factory do |factory_name|
  match do |model|
    Factory(factory_name).new_record?.should be_false
  end
end

# copied from spree/core for request specs
module AuthenticationHelpers
  def sign_in_as!(user)
    visit '/login'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Login'
  end

end

RSpec.configure do |c|
  c.include AuthenticationHelpers, :type => :request
end

