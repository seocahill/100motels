class EventPresenter

  def initialize(event, view)
    @event = event
    @view = view
  end

  def method_missing(*args, &block)
    @view.send(*args, &block)
  end

  def filepicker
    if event_owner?
      form_for @event do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: "Change Image", button_class: "btn", services: "COMPUTER, IMAGE_SEARCH, WEBCAM, INSTAGRAM, URL, FLICKR, FACEBOOK")
      end
    end
  end

  def image
    if @event.image.present?
      @event.image
    else
      "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg"
    end
  end

  def index_image
    if @event.image.present?
      filepicker_image_tag @event.image, w: 380, h: 200, fit: 'crop'
    else
      image_tag "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg", size: "380x200"
    end
  end

  def edit_button
    button_tag "Edit", type: "button", class: "btn btn-default edit-about", data: { toggle: "button" } if event_owner?
  end

  def about_section
    best_in_place_if event_owner?, @event, :about, type: :textarea, nil: "###Start Here", classes: "about", display_as: :about_html, activator: ".edit-about", html_attrs: {"rows" => 12, "cols" => 140, "spellcheck" => "true"}
  end

  def tickets_sold
    @event.orders.sum(:quantity)
  end

  def tickets_left
    left = @event.target - tickets_sold
    left > 0 ? left : "sold out"
  end

  def per_cent_sold
    percent = tickets_sold * @event.target / 100
    percent < 100 ? percent : 100
  end

  def left_to_go
     @event.date > DateTime.now ? distance_of_time_in_words(Time.now, @event.date) : "No time"
  end

  def is_visible
    if @event.visible?
      content_tag(:span, "visible", class: "label label-success")
    else
      content_tag(:span, "hidden", class: "label label-default")
    end
  end

  def earnings
    number_to_currency(@event.orders.to_a.sum { |order| order.quantity * order.ticket_price})
  end

  def on_sale?
    @event.date >= Time.now - 1.day
  end

  def event_owner?
    current_user == @event.user if current_user.present?
  end
end
