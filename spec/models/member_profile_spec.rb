require 'spec_helper'

describe MemberProfile do
  it { should have_one(:user).dependent(:destroy) }

  it { should respond_to(:auth_token)}
  it { should respond_to(:avatar)}
  it { should respond_to(:confirmation_sent_at)}
  it { should respond_to(:confirmation_token)}
  it { should respond_to(:email)}
  it { should respond_to(:name)}
  it { should respond_to(:password)}
  it { should respond_to(:password_reset_sent_at)}
  it { should respond_to(:password_reset_token)}

  it { should validate_presence_of :email }
  it { should_not allow_value("test@test").for(:email) }

  describe "#send_password_reset" do
    let(:user) { create(:member_user) }

    it "generates a unique password_reset_token each time" do
      user.profile.send_password_reset
      last_token = user.profile.password_reset_token
      user.profile.send_password_reset
      user.profile.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.profile.send_password_reset
      user.profile.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user.profile" do
      user.profile.send_password_reset
      last_email.to.should include(user.profile.email)
    end
  end

  describe "#send_admin_invitation" do
    let(:invitee) { create(:member_user)}
    let(:event) { create(:event) }
    let(:inviter) { event.users.first }

    it "delivers an email to the invitee" do
      inviter.profile.send_admin_invitation(invitee.profile.id, event.id)
      last_email.to.should include(inviter.profile.email)
    end
  end

  describe "#confirm!" do
    let(:user) { create(:member_user)}
    it "deliver and email with the confirmation instructions" do
      user.profile.confirm!
      last_email.to.should include(user.profile.email)
    end
  end

  describe "become_member" do
    let(:current_user) { create(:guest_user) }

    it "should change a guest user to a member" do
      # current_user.profile = subject
      # expect(current_user.profile_type).to eq "MemberProfile"
      pending
    end

    it "should change the status of a users events to member" do
      # event = create(:event, artist: "Seo Cahill")
      # current_user.events << event
      # current_user.become_member(subject)
      # expect(event.state).to eq :member
      pending
    end
  end
end
