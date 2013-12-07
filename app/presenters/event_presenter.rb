class EventPresenter

  def initialize(view)
    @view = view
  end

  def method_missing(*args, &block)
    @view.send(*args, &block)
  end

  def filepicker(event)
    if event_owner?(event)
      icon = content_tag(:i, '', class: "fa fa-picture-0")
      form_for event do |f|
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: '<i class="fa fa-picture-o"></i>', button_class: "btn btn-default btn-lg", services: "COMPUTER, IMAGE_SEARCH, WEBCAM, INSTAGRAM, URL, FLICKR, FACEBOOK")
      end
    end
  end

  def image(event)
    if event.image.present?
      event.image
    else
      nil
    end
  end

  def index_image(event)
    if event.image.present?
      filepicker_image_tag event.image, w: 380, h: 200, fit: 'crop'
    else
      image_tag "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg", size: "380x200"
    end
  end

  def edit_button(event)
    button_tag "Edit", type: "button", class: "btn btn-default btn-lg edit-about", data: { toggle: "button" } if event_owner?(event)
  end

  def about_section(event)
    best_in_place_if event_owner?(event), event, :about, type: :textarea, nil: "###Start Here", classes: "about", display_as: :about_html, activator: ".edit-about",html_attrs: {"rows" => 12, "cols" => 140, "spellcheck" => "true"}
  end

  def tickets_sold(event)
    event.orders.sum(:quantity)
  end

  def tickets_left(event)
    left = event.target - tickets_sold(event)
    left > 0 ? left : "sold out"
  end

  def per_cent_sold(event)
    percent = tickets_sold(event) * event.target / 100
    percent < 100 ? percent : 100
  end

  def per_cent_left(event)
    100 - per_cent_sold(event)
  end

  def left_to_go(event)
     event.date > DateTime.now ? distance_of_time_in_words(Time.now, event.date) : "No time"
  end

  def is_visible(event)
    if event.visible?
      content_tag(:span, "visible", class: "label label-success")
    else
      content_tag(:span, "hidden", class: "label label-default")
    end
  end

  def earnings(event)
    number_to_currency(event.orders.to_a.sum { |order| order.quantity * order.ticket_price})
  end

  def on_sale?(event)
    event.date >= Time.now - 1.day
  end

  def event_owner?(event)
    current_user == event.user if current_user.present?
  end
end
