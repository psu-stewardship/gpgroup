require 'thor'
require 'gpgme'

class GPGroup < Thor
  include Thor::Actions

  # The directory where we keep templates for copy_file, etc.
  source_root File.expand_path("../../templates/", __FILE__)

  desc "init", "Creates the initial .gpg-known-keys and .gpg-recipients"
  def init
    empty_directory ".gpg-known-keys"
    copy_file "gpg-known-keys/README", ".gpg-known-keys/README"
    copy_file "gpg-recipients", ".gpg-recipients"
  end

  desc "import", "Imports the public gpg keys under .gpg-known-keys"
  def import
    Dir.entries(".gpg-known-keys").each do |filename|
      if filename =~ /\.gpg$/
        say_status "import", filename
        GPGME::Key.import(File.open(".gpg-known-keys/#{filename}"))
      else
        unless filename == '.' || filename == '..' || filename == 'README'
          say_status "skipped", "#{filename} (doesn't end with .gpg)", :red
        end
      end
    end
  end

  desc "encrypt", "Encrypt or re-encrypt the given filename or path according to recipients"
  def encrypt(path)
    crypto = GPGME::Crypto.new
    input_file = File.open(path, 'r')
    output_file = File.open("#{path}.gpg", 'w')
    crypto.encrypt input_file, output: output_file, recipients: recipients, armor: true
    FileUtils.rm_f(path)
  end

  def recipients
    # TODO: read this from the .gpg-recipients files
    ["test@example.com"]
  end

end