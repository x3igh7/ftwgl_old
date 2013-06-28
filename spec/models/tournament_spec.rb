require 'spec_helper'

describe Tournament do
  it { should validate_presence_of(:name) }
end
