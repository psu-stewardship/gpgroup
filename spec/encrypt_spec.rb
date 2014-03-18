require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  let(:gpgroup) { GPGroup.new([], quiet: true) }

  before do
    initialize_repo_dir
  end

  describe "the encrypt command" do
    let(:command) { GPGroup.commands['encrypt'] }

    it "is defined" do
      command.should_not be_nil
    end

    it "has a description" do
      command.description.should_not be_empty
    end

    context "when run inside an existing repository" do
      let(:fixtures_path) { $root.join("spec/fixtures") }

      context "with a secret file inside it" do
        let(:secret_file) { repo_dir.join("secret.txt") }
        let(:encrypted_secret_file) { repo_dir.join("secret.txt.gpg") }
        let(:secret_message) { "This is the secret message." }
        let(:gpg) { GPGME::Crypto.new }
        before do
          File.open(secret_file, 'w') do |f|
            f.write secret_message
          end
        end

        context "and when the recipient is alice" do
          let(:recipients_file) { repo_dir.join(".gpg-recipients") }
          before do
            File.open(recipients_file, 'a') do |f|
              f.puts "alice@example.com"
            end
          end

          context "when bob runs the encrypt command" do
            let(:decrypted_message) { gpg.decrypt(File.open(encrypted_secret_file), password: 'secret').to_s }
            before do
              GPGME::Engine.home_dir = $root.join("spec/fixtures/bob").to_s
              gpgroup.encrypt("secret.txt")
            end

            it "creates an encrypted version of the file" do
              encrypted_secret_file.should exist
              encrypted_secret_file.read.should =~ /BEGIN PGP MESSAGE/
              encrypted_secret_file.read.should_not =~ /secret message/
            end

            it "removes the original secret file" do
              secret_file.should_not exist
            end

            specify "alice can decrypt the file" do
              GPGME::Engine.home_dir = $root.join("spec/fixtures/alice").to_s
              decrypted_message.should == secret_message
            end

            specify "bob can not decrypt the file" do
              GPGME::Engine.home_dir = $root.join("spec/fixtures/bob").to_s
              expect { decrypted_message }.to raise_error(GPGME::Error::DecryptFailed)
            end

          end

        end

      end
    end
  end
end

