class EventDecorator < ApplicationDecorator
  delegate_all

  def header
    content_tag :header, h.title(model.artist, model.venue, model.date)
  end

  def toggle_visible
    if event_owner? && current_user.profile_type == "MemberProfile"
      switch = best_in_place model, :visible, :type => :checkbox, collection: ["Click to Publish Event", "Click to Hide Event"]
    elsif current_user
      "Sign up to Publish"
    end
  end

  def edit
    link_to "Edit in form", edit_organizer_event_path(model), class: "" if event_owner?
  end

  def filepicker
    if event_owner?
      form_for model do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();")
      end
    end
  end

  def image
    if model.image?
      model.image
      # filepicker_image_tag model.image, width: 460, height: 300, fit: 'crop'
      # fit option are clip crop scale max
    else
      image_tag "//quickimage.it/300&text=Artist"
    end
  end

  def title
    best_in_place_if event_owner?, model, :artist
  end

  def date
    best_in_place_if event_owner?, model, :date, type: :date, display_with: lambda { |v| v.strftime("%a, %d %b %Y") }
  end

  def venue
    best_in_place_if event_owner?, model, :venue
  end

  def doors
    best_in_place_if event_owner?, model, :doors, display_with: lambda { |v| v.strftime("%l:%M %p")}
  end

  def sales
    sales = model.orders.sum(:quantity)
    model.target - sales
  end

  def price
    if on_sale?
      best_in_place_if event_owner?, model, :ticket_price, classes: "ticket-price", display_with: :number_to_currency
    end
  end

  def about
    best_in_place_if event_owner?, model, :about, :type => :textarea,
                          :nil => "Click me to add content!", :display_with => :simple_format
  end

  def map
    image_tag "http://maps.google.com/maps/api/staticmap?size=250x250&sensor=false&zoom=16&markers=#{model.location.latitude}%2C#{model.location.longitude}"
  end

  def video
    best_in_place model, :video, :nil => "Click me to add a Youtube or Vimeo url, e.g. http://youtu.be/TZLwfyVYJJw" if event_owner?
  end

  def video_iframe
    if model.video_html.present?
      model.video_html
    else
      image_tag "//quickimage.it/630x430&text=Vimeo", class: "align_center"
    end
  end

  def music
    best_in_place model, :music, :nil => "Click me to add a Soundcloud url, e.g. http://youtu.be/TZLwfyVYJJw" if event_owner?
  end

  def music_iframe
    if model.music_html.present?
      model.music_html
    else
      image_tag "//quickimage.it/565x170&text=Soundcloud+playlist", class: "align_left"
    end
  end

  def ticket_form
    render 'form' if on_sale?
  end

  def order_total
    if on_sale?
      number_to_currency raw(
        '<span class="order-total"></span>
        <small><a href="#" class="" data-toggle="popover"
        title="" data-content="Card Processing is 2.9% +
        30c, our fee is only 1%!" data-original-title=
        "Processing Fees" data-placement="bottom">inc.
        charges</a></small>'
        )
    else
      "The Shows Over!"
    end
  end

  def on_sale?
    d = model.date
    t = model.doors
    dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
    dt >= Time.now
  end

  def event_owner?
    if current_user.present?
      current_user.id == model.users.first.id
    else
      false
    end
  end
end
