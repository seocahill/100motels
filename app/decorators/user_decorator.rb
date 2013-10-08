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
    model.email
  end

  def name
    model.name
  end

  def user_email
    model.email
  end

  def user_name
    model.name
  end

  def password_reset
    link_to "Reset Password", password_resets_path(email: model.profile.email), method: :post if model.profile_type == "MemberProfile"
  end
end
