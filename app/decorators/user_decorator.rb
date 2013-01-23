class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar
    h.filepicker_image_tag model.profile.avatar, width: 300, height: 300, fit: 'crop' if model.profile.avatar
  end

  def edit
    h.link_to "Edit Account Settings", h.edit_member_profile_path(model.profile.id), class: "btn btn-block"
  end

  def email
    model.profile_type == "MemberProfile" ? model.profile.email : "your account"
  end

  def name
    model.profile_type == "MemberProfile" ? model.profile.name : "guest"
  end

  def card
    if model.customer_id.present?
      "#{model.type} ending #{model.last4} \n expires #{model.exp_month} #{model.exp_year}"
    end
  end

  def update_card
    h.form_tag h.change_card_user_path, method: :put do
           h.raw %Q{<script src="https://button.stripe.com/v1/button.js"
            class="stripe-button" data-panel-label="Save" data-label="Add Card" data-key="<%= ENV['STRIPE_PUBLIC_KEY'] %>" > </script>}
    end
  end

  def current_user

  end
end
