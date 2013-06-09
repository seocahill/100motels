class UserDecorator < ApplicationDecorator
  delegate_all

  def user_avatar
    if model.profile.avatar
      filepicker_image_tag model.profile.avatar, width: 200, height: 200, fit: 'clip'
    else
      raw '<img src="//placehold.it/200&text=Your+Avatar" alt="">'
    end
  end

  def email
    model.profile_type == "MemberProfile" ? model.profile.email : "save your account"
  end

  def name
    model.profile_type == "MemberProfile" ? model.profile.name : "guest"
  end

  def user_email
    if model.profile_type == "MemberProfile"
      profile = model.profile
      best_in_place profile, :email
    else
      "Save your account"
    end
  end

  def user_name
    if model.profile_type == "MemberProfile"
      profile = model.profile
      best_in_place profile, :name, nil: "choose a username"
    else
      "Guest User"
    end
  end

  def password_reset
    link_to "Reset Password", password_resets_path(email: model.profile.email), method: :post if model.profile_type == "MemberProfile"
  end
end
