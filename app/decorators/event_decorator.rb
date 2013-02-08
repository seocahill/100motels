class EventDecorator < ApplicationDecorator
  delegate_all

  def header
    content_tag :header, h.title(model.artist, model.venue, model.date)
  end

  def active
    switch = best_in_place model, :visible, :type => :checkbox, collection: ["Click to Publish Event", "Click to Hide Event"] if event_owner?
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
      filepicker_image_tag model.image, width: 300, height: 300, fit: 'crop'
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
    best_in_place_if event_owner?, model, :ticket_price, display_with: :number_to_currency
  end

  def about
    best_in_place_if event_owner?, model, :about, :type => :textarea, :ok_button => 'Save', :cancel_button => 'Cancel',
                          :nil => "Click me to add content!", :display_with => :simple_format
  end

  def location
    image_tag "http://maps.google.com/maps/api/staticmap?size=450x300&sensor=false&zoom=16&markers=#{model.location.latitude}%2C#{model.location.longitude}"
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

  def event_owner?
    if current_user.present?
      current_user.id == model.users.first.id
    else
      false
    end
  end
end
