# Define the root path of the project
$root = Pathname.new(File.expand_path(File.dirname(__FILE__) + '/..'))

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Before each spec, set up a fresh keyring from our fixtures.
  config.before(:each) do
    FileUtils.rm_rf($root.join("tmp/gnupg"))
    FileUtils.cp_r($root.join("spec/fixtures/bob"), $root.join("tmp/gnupg"))
    require 'gpgme'
    GPGME::Engine.home_dir = $root.join("tmp/gnupg").to_s
  end
end
