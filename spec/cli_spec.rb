require 'spec_helper'

describe "The bin/gpgroup executable" do
  let(:output) { `bin/gpgroup` }

  it "returns successfully" do
    output
    $?.should be_success
  end
  it "displays the command line help by default" do
    output.should =~ /gpgroup help/
  end
  it "lists the available commands" do
    output.should =~ /gpgroup init/
  end

end
