require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  let(:gpgroup) { GPGroup.new([], quiet: true) }

  before do
    initialize_repo_dir
  end

  describe "the import command" do
    let(:command) { GPGroup.commands['import'] }

    it "is defined" do
      command.should_not be_nil
    end

    it "has a description" do
      command.description.should_not be_empty
    end

    context "when run inside an existing repository" do
      let(:fixtures_path) { $root.join("spec/fixtures") }

      context "in the .gpg-known-keys directory" do

        context "when there are no public keys" do
          it "does nothing" do
            before = GPGME::Key.find(:public).map(&:email)
            gpgroup.import
            after = GPGME::Key.find(:public).map(&:email)
            before.should == after
          end
        end

        context "when there are new public keys" do
          before do
            FileUtils.cp(fixtures_path.join("jrp22@psu.edu.gpg"), repo_dir.join(".gpg-known-keys/"))
          end
          it "imports them" do
            before = GPGME::Key.find(:public).map(&:email)
            before.should_not include('jrp22@psu.edu')
            gpgroup.import
            after = GPGME::Key.find(:public).map(&:email)
            after.should include('jrp22@psu.edu')
            new_emails = after - before
            new_emails.should == %w{ jrp22@psu.edu }
          end
        end

        context "when there are public keys that we've already imported" do
          before do
            FileUtils.cp(fixtures_path.join("jrp22@psu.edu.gpg"), repo_dir.join(".gpg-known-keys/"))
            gpgroup.import # import this key once
            GPGME::Key.find(:public).map(&:email).should include('jrp22@psu.edu')
          end
          it "does nothing" do
            before = GPGME::Key.find(:public).map(&:email)
            gpgroup.import # now try to import it again
            after = GPGME::Key.find(:public).map(&:email)
            before.should == after
          end
        end

        context "when there are unrecognized files" do
          before do
            FileUtils.touch(repo_dir.join(".gpg-known-keys/no-extension"))
          end
          it "prints a warning" do
            gpgroup.shell.should_receive(:say_status).with("skipped", "no-extension (doesn't end with .gpg)", :red)
            gpgroup.import
          end
        end
      end

    end
  end
end
