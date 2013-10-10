class EventDecorator < ApplicationDecorator
  delegate_all

  def private_or_public
    if model.visible
      raw('<span class=""><i class="icon-eye-open"></i> Visibility: published</span>')
    else
      raw('<span class=""><i class="icon-eye-close"></i> Visibility: private</span>')
    end
  end

  def toggle_visible
    if event_owner?
      switch = best_in_place model, :visible, :type => :checkbox, collection: ["Publish Event", "Hide Event"], data: {current_url: request.path}, classes: "btn"
    elsif current_user
      link_to "Sign up to Publish", signup_path, class: 'btn'
    end
  end

  def payments_locked?
    false
  end

  def lock
    "not used"
  end

  def edit
    "fixme"
  end

  def filepicker
    if event_owner?
      form_for model do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: "Change Image", button_class: "btn", services: "COMPUTER, IMAGE_SEARCH, WEBCAM, INSTAGRAM, URL, FLICKR, FACEBOOK")
      end
    end
  end

  def image
    if model.image.present?
      model.image
    else
      "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg"
    end
  end

  def bip_title
    best_in_place_if event_owner?, model, :name, :nil => "A Title for Your Event"
  end


  def formatted_date
    if model.orders.nil?
      best_in_place_if event_owner?, model, :date, type: :date, classes: "datepicker" , display_with: :time_tag, classes: ""
    elsif event_owner?
      time_tag(model.date, class: "defer-date", data: { toggle: "popover", content: "Can't change the date when you have orders! Use Defer Event controls in your admin area instead.", placement: "right" })
    else
      time_tag(model.date)
    end
  end

  def sales
    sales = model.orders.sum(:quantity)
  end

  def edit_icon
    raw('<i class="icon-edit"></i>') if event_owner?
  end

  def price
    best_in_place_if event_owner?, model, :ticket_price, classes: "price", display_with: :number_to_currency, nil: "free event"
  end

  def about_section
    best_in_place_if event_owner?, model, :about, :type => :textarea, nil: "#{render 'instructions'}", classes: ["about"], display_as: :about_html, activator: ".edit-about", html_attrs: {"rows" => 12, "cols" => 140}
  end

  def ticket_form
    render 'form'
  end

  def order_total
      number_to_currency raw(
        '<span class="order-total"></span>'
        )
  end

  def per_cent_funded
    # sales = model.orders.sum(:quantity)
    25
  end

  def left_to_go
     model.date > DateTime.now ? distance_of_time_in_words(Time.now, model.date, include_seconds = false) : "No time"
  end

  def on_sale?
    # d = model.date
    # d >= Time.now
    true
  end

  def event_owner?
    # if current_user.present?
    #   model.event_users.where(user_id: current_user.id).where("event_users.state >= 0").present?
    # else
    #   false
    # end
    true
  end

  def event_admin?
    # if current_user.present?
    #   model.event_users.where(user_id: current_user.id).where("event_users.state > 1").present?
    # else
    #   false
    # end
    true
  end
end
