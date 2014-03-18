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

      context "in the .gpg-known-keys directory" do

        context "when there are no public keys" do
          it "does nothing" do
            expect { gpgroup.import }.not_to change { known_emails }
          end
        end

        context "when there is a known key" do
          before do
            FileUtils.cp(fixtures_path.join("jrp22@psu.edu.gpg"), repo_dir.join(".gpg-known-keys/"))
          end
          context "that we haven't imported" do
            it "imports it" do
              expect { gpgroup.import }.to change { known_emails }.by(['jrp22@psu.edu'])
            end
          end
          context "that we have already imported" do
            before do
              gpgroup.import
            end
            it "does nothing when imported a second time" do
              expect { gpgroup.import }.not_to change { known_emails }
            end
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
