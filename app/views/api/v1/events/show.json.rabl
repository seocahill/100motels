object @event
attributes :artist, :venue, :date
child :line_items do
  attributes :quantity
  glue :order do
    attributes :name, :email
  end
end