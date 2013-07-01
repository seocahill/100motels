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
    if event_owner? && current_user.profile_type == "MemberProfile"
      switch = best_in_place model, :visible, :type => :checkbox, collection: ["Publish Event", "Hide Event"], data: {current_url: request.path}, classes: "btn"
    elsif current_user
      link_to "Sign up to Publish", signup_path, class: 'btn'
    end
  end

  def payments_locked?
    admins = EventUser.where("event_id = ? AND state > 1", model.id)
    if admins.any? {|admin| admin.payment_lock }
      raw('<span class="label label-important"><i class="icon-lock"></i> Payments are locked!</span>')
    else
      raw('<span class="label label-success"><i class="icon-unlock"></i> Payments unlocked!</span>')
    end
  end

  def lock
    event_user = model.event_users.where(user_id: current_user.id).first
    switch = best_in_place event_user, :payment_lock, type: :checkbox, collection: ["Lock", "Unlock"], path: organizer_event_event_user_path(model, event_user)
  end

  def edit
    link_to "Edit in Form", edit_organizer_event_path(model), class: "" if event_owner?
  end

  def filepicker
    if event_owner?
      form_for model do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: "Change Image", button_class: "btn btn-inverse", services: "COMPUTER, IMAGE_SEARCH, WEBCAM, INSTAGRAM, URL, FLICKR, FACEBOOK")
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
    best_in_place_if event_owner?, model, :title, :nil => "A Title for Your Event"
  end

  def bip_artist
    best_in_place_if event_owner?, model, :artist, nil: "Headline Artist"
  end
  def bip_first_support
    best_in_place_if event_owner?, model, :first_support, nil: "Support Artist"
  end
  def bip_second_support
    best_in_place_if event_owner?, model, :second_support, nil: "Support Artist"
  end
  def bip_third_support
    best_in_place_if event_owner?, model, :third_support, nil: "Support Artist"
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

  def venue
    best_in_place_if event_owner?, model, :venue
  end

  def doors
    best_in_place_if event_owner?, model, :doors, display_with: lambda { |v| v.strftime("%l:%M %p")}, classes: "doors"
  end

  def sales
    sales = model.orders.sum(:quantity)
    model.target - sales
  end

  def edit_icon
    raw('<i class="icon-edit"></i>') if event_owner?
  end

  def price
    best_in_place_if event_owner?, model, :ticket_price, classes: "price", display_with: :number_to_currency, nil: "free event"
  end

  def about_section
    best_in_place_if event_owner?, model, :about, :type => :textarea, nil: "#{render 'instructions'}", classes: ["span11", "about"], display_as: :about_html
  end

  def venue_address
    location = model.location
    best_in_place_if event_owner?, location, :address
  end

  def map
    h.link_to(image_tag("https://maps.google.com/maps/api/staticmap?size=250x250&sensor=false&zoom=16&markers=#{model.location.latitude}%2C#{model.location.longitude}"), "https://maps.google.com/?ll=#{model.location.latitude},#{model.location.longitude}")
  end

  def video
    best_in_place model, :video, :nil => "Click me to add a Youtube or Vimeo url, e.g. http://youtu.be/TZLwfyVYJJw" if event_owner?
  end

  def video_iframe
    if model.video_html.present?
      model.video_html
    else
      raw('<iframe width="420" height="315" src="https://www.youtube.com/embed/2H_SsrNE8eI" frameborder="0" allowfullscreen></iframe>')
    end
  end

  def music
    best_in_place model, :music, :nil => "Click me to add a Soundcloud url, e.g. https://soundcloud.com/creteboom/sets/them-bones-need-oxygen" if event_owner?
  end

  def music_iframe
    if model.music_html.present?
      model.music_html
    else
      raw('<iframe width="100%" height="450" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F745034&amp;color=0050ff&amp;auto_play=false&amp;show_artwork=true"></iframe>')
    end
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
    sales = model.orders.sum(:quantity)
    if sales > 0
      ((sales.to_d / model.target.to_d)*100.0).to_i
    else
      0
    end
  end

  def left_to_go
     model.date > DateTime.now ? distance_of_time_in_words(Time.now, model.date, include_seconds = false) : "No time"
  end

  def on_sale?
    d = model.date
    t = model.doors
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
    dt >= Time.now
  end

  def event_owner?
    if current_user.present?
      model.event_users.where(user_id: current_user.id).where("event_users.state >= 0").present?
    else
      false
    end
  end

  def event_admin?
    if current_user.present?
      model.event_users.where(user_id: current_user.id).where("event_users.state > 1").present?
    else
      false
    end
  end
end
