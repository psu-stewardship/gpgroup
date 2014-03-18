# Define the root path of the project
$root = Pathname.new(File.expand_path(File.dirname(__FILE__) + '/..'))

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Include our own custom helpers
  require "helpers/keyring_helper"
  require "helpers/repository_helper"
  config.include KeyringHelper
  config.include RepositoryHelper

  # Before each spec, set up fresh keyrings from our fixtures.
  config.before(:each) do
    reset_keyrings
  end

end
