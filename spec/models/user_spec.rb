require 'spec_helper'

describe User do
  it { should have_many :events }
  it { should respond_to :send_password_reset }

  it "has a valid user factory" do
    create(:user).should be_valid
  end

  describe '#generate_token' do
    it "generates a unique token" do
      SecureRandom.stub!(:urlsafe_base64).and_return("first try","second try")
      first_user = User.create
      new_user = User.create
      expect(new_user.auth_token).to eq "second try"
    end
  end

  describe "#connect" do
    subject(:user) { User.create }
    it "assigns the stripe api_key" do
      OmniAuth.config.add_mock(:stripe_connect, {:uid => '12345', :credentials => { :token => 'secret' }})
      request = double('request', env: {})
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:stripe_connect]
      user.connect(request)
      expect(user.api_key).to eq 'secret'
    end
  end

end
