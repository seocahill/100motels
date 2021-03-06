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
        f.filepicker_field(:image, onchange: "this.form.submit();", button_text: '<i class="fa fa-picture-o fa-2x"></i> ', button_class: "btn btn-default btn-lg", services: "COMPUTER, IMAGE_SEARCH, INSTAGRAM, URL, FLICKR")
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
      image_tag event.image, class: "img-responsive"
    else
      image_tag "https://s3-us-west-2.amazonaws.com/onehundredmotels/247915_156305404435251_2616225_n.jpg", class: "img-responsive"
    end
  end

  def edit_button(event)
    icon = content_tag(:i, '', class: "fa fa-edit fa-2x")
    content_tag(:a, icon, class: "btn btn-default btn-lg", id: "showEditor") if event_owner?(event)
  end

  def about_section(event)
    best_in_place_if event_owner?(event), event, :about, type: :textarea, ok_button: "Save", ok_button_class: "btn btn-lg btn-primary save-edit", cancel_button: "Cancel", cancel_button_class: "btn btn-default btn-lg cancel-edit", classes: "about", display_as: :about_html, activator: "#edit-about", html_attrs: {"rows" => 12, "cols" => 140, "spellcheck" => "true"}
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
    if current_user.present?
      current_user == event.user or current_user.superadmin?
    end
  end
end
