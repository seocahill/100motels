class EventsPresenter
  include AutoHtml

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


  def formatted_date
    if @event.orders.nil?
      best_in_place_if event_owner?, @event, :date, display_with: :time_tag
    else
      time_tag(@event.date)
    end
  end

  def sales
    sales = @event.orders.sum(:quantity)
  end

  def price
    best_in_place_if event_owner?, @event, :ticket_price, classes: "price", display_with: :number_to_currency, nil: "free event"
  end

  def about_section
    text = <<-END
      #Read this first!\n\n---\n\n###You can edit this page by clicking on any element that is marked with an  icon.
      All your changes should be saved automatically.\n\n
      ####This page uses redcarpet markdown for formating, you can also embed media objects and images.\n\n
      ####Don't forget to mention the lineup for the night:\n
      1. [Crete Boom](http://creteboom.com/).\n2. [Another Band](http://example.com/).\n\n
      > fuckin A\n\n
      ####Here's some Crete Boom vids, first youtube:\n\nhttp://www.youtube.com/watch?v=AQ_6sGiglm4\n\n
      then vimeo (try resizing the browser all embeds should be responsive)\n\nhttp://vimeo.com/57855999\n\n
      ####Here's a map for the venue\n\n
      https://maps.google.com/maps?q=irish+times&hl=en&ll=37.79483,-122.395914&spn=0.011411,0.019913&sll=37.793694,
      -122.395828&sspn=0.011412,0.019913&t=h&radius=0.65&hq=irish+times&z=16
    END
    placeholder = auto_html(text){ redcarpet; youtube; vimeo; google_map; link(:target => 'blank') }
    best_in_place_if event_owner?, @event, :about, type: :textarea, nil: placeholder, classes: "about", display_as: :about_html, activator: ".edit-about", html_attrs: {"rows" => 12, "cols" => 140, "spellcheck" => "true"}
  end


  def order_total
      number_to_currency raw(
        '<span class="order-total"></span>'
        )
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
     @event.date > DateTime.now ? distance_of_time_in_words(Time.now, @event.date, include_seconds = false) : "No time"
  end

  def is_visible
    if @event.visible?
      content_tag(:span, "visible", class: "label label-success")
    else
      content_tag(:span, "hidden", class: "label label-default")
    end
  end

  def earnings
    number_to_currency(@event.orders.sum { |order| order.quantity * order.ticket_price})
  end

  def on_sale?
    # d = @event.date
    # d >= Time.now
    true
  end

  def event_owner?
    current_user == @event.user if current_user.present?
  end
end
