require 'spec_helper'
require 'gpgroup'

describe GPGroup do

  it "inherits from Thor" do
    GPGroup.ancestors.should include(Thor)
  end

end
