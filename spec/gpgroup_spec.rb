require 'spec_helper'
require 'gpgroup'

describe GPGroup do
  it "inherits from Thor" do
    GPGroup.ancestors.should include(Thor)
  end
  describe 'the init command' do
    let(:command) { GPGroup.commands['init'] }
    it "is defined" do
      command.should_not be_nil
    end
    it "has a description" do
      command.description.should_not be_empty
    end
  end
end
