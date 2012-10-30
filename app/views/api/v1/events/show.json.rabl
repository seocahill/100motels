object @event
attributes :artist, :venue, :date
child :orders do
  attributes :quantity, :stripe_charge_id
end