class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar
    if model.profile.avatar
      filepicker_image_tag model.profile.avatar, width: 200, height: 200, fit: 'crop'
    else
      raw '<img src="//placehold.it/200&text=Your+Avatar" alt="">'
    end
  end

  def edit
    link_to "Edit Account Settings", edit_member_profile_path(model.profile.id), class: "btn btn-block" if current_user?
  end

  def email
    if model.profile_type == "MemberProfile"
      profile = model.profile
      best_in_place profile, :email
    else
      "Save your account"
    end
  end

  def name
    if model.profile_type == "MemberProfile"
      profile = model.profile
      best_in_place profile, :name, nil: "choose a username"
    else
      "Guest User"
    end
  end

  def card
    if model.customer_id.present?
      "#{model.type} ending #{model.last4} \n expires #{model.exp_month} #{model.exp_year}"
    end
  end

  def update_card
    form_tag change_card_user_path, method: :put do
           raw %Q{<script src="https://button.stripe.com/v1/button.js"
            class="stripe-button" data-panel-label="Save" data-label="Add Card" data-key="<%= ENV['STRIPE_PUBLIC_KEY'] %>" > </script>}
    end
  end

  def password_reset
    link_to "Reset Password", password_resets_path(email: model.profile.email), method: :post if model.profile_type == "MemberProfile"
  end

  def current_user?
    if current_user
      model.id == current_user.id?
    end
  end
end
