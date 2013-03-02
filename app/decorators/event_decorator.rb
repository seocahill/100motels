class EventDecorator < ApplicationDecorator
  delegate_all

  def header
    content_tag :header, h.title(model.artist, model.venue, model.date)
  end

  def toggle_visible
    if event_owner? && current_user.profile_type == "MemberProfile"
      switch = best_in_place model, :visible, :type => :checkbox, collection: ["Publish Event", "Hide Event"]
    elsif current_user
      "Sign up to Publish"
    end
  end

  def edit
    link_to "Edit in Form", edit_organizer_event_path(model), class: "" if event_owner?
  end

  def filepicker
    if event_owner?
      form_for model do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: "Change Image", button_class: "link-button-show")
      end
    end
  end

  def image
    if model.image?
      model.image
    else
      "http://route66motorcycletour.com/images/BlueSwallow.jpg"
    end
  end

  def title
    best_in_place_if event_owner?, model, :title, :nil => "A Title for Your Event"
  end

  def artist
    best_in_place_if event_owner?, model, :artist
  end

  def date
    best_in_place_if event_owner?, model, :date, type: :date, classes: "datepicker" , display_with: :time_tag, classes: ""
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
    best_in_place_if event_owner?, model, :ticket_price, classes: "ticket_price", display_with: :number_to_currency
  end

  def about_section
    best_in_place_if event_owner?, model, :about, :type => :textarea, :display_with => :simple_format, nil: "#{render 'instructions'}"
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
        '<span class="order-total"></span>
        <small><a href="#" class="" data-toggle="popover"
        title="" data-content="Card Processing is 2.9% +
        30c, our fee is only 1%!" data-original-title=
        "Processing Fees" data-placement="bottom">inc.
        charges</a></small>'
        )
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
