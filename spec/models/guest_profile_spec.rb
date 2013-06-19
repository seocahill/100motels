require 'spec_helper'

describe GuestProfile do

  it { should have_one(:user).dependent(:destroy)}

  it "should be a guest" do
    expect(subject.guest?).to be_true
  end

  it "should not have a customer_id" do
    expect(subject.customer_id?).to be_false
  end

end
