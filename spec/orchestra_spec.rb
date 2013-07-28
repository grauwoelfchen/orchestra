require 'spec_helper'

describe Orchestra do
  it 'should have a version number' do
    Orchestra::VERSION.should_not be_nil
  end

  it 'should do something useful' do
    false.should be_true
  end
end
