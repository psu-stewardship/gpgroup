require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  let(:args) { [] }
  let(:options) {{ quiet: true }}
  let(:gpgroup) { GPGroup.new(args, options) }

  describe "the init command" do
    let(:command) { GPGroup.commands['init'] }

    it "is defined" do
      command.should_not be_nil
    end

    it "has a description" do
      command.description.should_not be_empty
    end

    context "when run inside a new directory" do
      let(:tmp_dir) { $root.join("tmp") }
      let(:repo_dir) { tmp_dir.join("repo") }
      before do
        FileUtils.rm_rf(tmp_dir)
        FileUtils.mkpath(repo_dir)
        FileUtils.chdir(repo_dir)
        gpgroup.init
      end

      it "creates the .gpg-known-keys directory" do
        repo_dir.join(".gpg-known-keys").should be_directory
      end

      let(:readme_file) { repo_dir.join(".gpg-known-keys/README") }
      it "creates a README that explains how to use the .gpg-known-keys directory" do
        readme_file.should exist
        readme_file.read.should =~ /how to use/
      end

      let(:recipients_file) { repo_dir.join(".gpg-recipients") }
      it "installs a sample .gpg-recipients file" do
        recipients_file.should exist
        recipients_file.read.should =~ /This file contains/
      end

    end
  end

end