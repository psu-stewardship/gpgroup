require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  let(:args) { [] }
  let(:options) {{ quiet: true }}
  let(:gpgroup) { GPGroup.new(args, options) }
  it "inherits from Thor" do
    GPGroup.ancestors.should include(Thor)
  end
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
      it "creates the .gpg-known-keys file" do
        repo_dir.join(".gpg-known-keys").should exist
      end
    end
  end
end
