require 'spec_helper'

describe User do
  it { should have_many :orders }
  it { should have_many :event_users }
  it { should have_many :events }
  it { should belong_to :profile }

  it "generates a unique token" do
    SecureRandom.stub!(:urlsafe_base64).and_return("first try","second try")
    first_user = User.create
    new_user = User.create
    expect(new_user.auth_token).to eq "second try"
  end

  it "assigns the stripe api_key" do
    pending
  end
end
