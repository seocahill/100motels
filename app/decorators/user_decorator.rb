class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar
    if model.profile.avatar
      filepicker_image_tag model.profile.avatar, width: 300, height: 300, fit: 'crop'
    else
      raw '<img src="//placehold.it/200&text=Your+Avatar" alt="">'
    end
  end

  def edit
    link_to "Edit Account Settings", edit_member_profile_path(model.profile.id), class: "btn btn-block" if current_user?
  end

  def email
    model.profile_type == "MemberProfile" ? model.profile.email : "Save your account"
  end

  def name
    if model.profile_type == "MemberProfile"
      model.profile.name || "choose a username"
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

  def current_user?
    if current_user
      model.id == current_user.id?
    end
  end
end
