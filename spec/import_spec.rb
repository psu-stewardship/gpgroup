require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  let(:args) { [] }
  let(:options) {{ quiet: true }}
  let(:gpgroup) { GPGroup.new(args, options) }

  describe "the import command" do
    let(:command) { GPGroup.commands['import'] }

    it "is defined" do
      command.should_not be_nil
    end

    it "has a description" do
      command.description.should_not be_empty
    end

  end
end
