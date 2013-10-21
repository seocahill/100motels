require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { create(:user)}
    let(:mail) { UserMailer.password_reset(User.last.id) }

    it "renders the headers" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["seo@100motels.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("If you did not request your password to be reset please ignore this email and your password will stay as it is.")
    end
  end

end
