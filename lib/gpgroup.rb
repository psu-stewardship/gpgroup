require 'thor'

class GPGroup < Thor
  include Thor::Actions

  desc "init", "Creates the initial .gpg-known-keys and .gpg-recipients"
  def init
    create_file ".gpg-known-keys"
  end

end