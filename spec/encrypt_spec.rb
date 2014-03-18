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

    context "when alice is the sole recipient" do
      before do
        File.write(".gpg-recipients", "alice@example.com")
      end

      context "and when bob encrypts a file" do
        let(:secret_file) { repo_dir.join("secret.txt") }
        let(:secret_message) { "This is the secret message." }
        before do
          as_bob do
            File.write(secret_file, secret_message)
            gpgroup.encrypt(secret_file)
          end
        end

        it "removes the original secret file" do
          secret_file.should_not exist
        end

        let(:encrypted_secret_file) { repo_dir.join("secret.txt.gpg") }
        it "creates an encrypted version of the file" do
          encrypted_secret_file.should exist
          encrypted_secret_file.read.should =~ /BEGIN PGP MESSAGE/
          encrypted_secret_file.read.should_not =~ /secret message/
        end

        specify "alice can decrypt the file" do
          as_alice do
            decrypt_file(encrypted_secret_file).should == secret_message
          end
        end

        specify "bob can not decrypt the file" do
          as_bob do
            expect {
              decrypt_file(encrypted_secret_file)
            }.to raise_error(GPGME::Error::DecryptFailed)
          end
        end
      end

    end
  end
end

