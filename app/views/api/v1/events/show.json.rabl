object @event
attributes :artist, :venue, :date
child :tickets do
  attributes :number, :admitted
end