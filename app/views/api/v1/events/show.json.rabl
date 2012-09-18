object @event
attributes :artist, :venue, :date
child :line_items do
  attributes :quantity
end