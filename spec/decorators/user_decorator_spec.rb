require 'spec_helper'

describe UserDecorator do
  let(:decorator) { UserDecorator.new(object) }
  let(:object) { create(:member_user) }

  it "uses a test view context from ApplicationController" do
    expect(Draper::ViewContext.current.controller).to be_an ApplicationController
  end

  it "will display a placeholder when the avatar isn't present" do
    expect(decorator.user_avatar).to include "//placehold.it/200&text=Your+Avatar"
  end

  it "will display the user avatar" do
    object.profile.stub(avatar: "https://filepicker.io/my-image.png")
    expect(decorator.user_avatar).to include "https://filepicker.io/my-image.png"
  end

  context 'when member profile' do
    it "will display the user name" do
      expect(decorator.name).to eq object.profile.name
    end

    it "will display the user email" do
      expect(decorator.email).to eq object.profile.email
    end

    it "will display editable field for email" do
      expect(decorator.user_email).to include object.profile.email
    end

    it "will display editable field for name" do
      expect(decorator.user_name).to include object.profile.name
    end

    it "will display the password reset link" do
      expect(decorator.password_reset).to_not be_nil
    end
  end

  context 'when guest profile' do
    let(:object) { create(:guest_user) }

    it "will display a placeholder the user name" do
      expect(decorator.name).to eq "guest"
    end

    it "will display a placeholder the user email" do
      expect(decorator.email).to eq "save your account"
    end

    it "will display a placeholder editable field for email" do
      expect(decorator.user_email).to eq "Save your account"
    end

    it "will display a placeholder editable field for name" do
      expect(decorator.user_name).to eq "Guest User"
    end

    it "will not display a password reset link" do
      expect(decorator.password_reset).to be_nil
    end
  end
end