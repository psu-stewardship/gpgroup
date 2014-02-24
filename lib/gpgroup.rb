require 'thor'

class GPGroup < Thor
  include Thor::Actions

  # The directory where we keep templates for copy_file, etc.
  source_root File.expand_path("../../templates/", __FILE__)

  desc "init", "Creates the initial .gpg-known-keys and .gpg-recipients"
  def init
    empty_directory ".gpg-known-keys"
    copy_file "gpg-known-keys/README", ".gpg-known-keys/README"
  end

end