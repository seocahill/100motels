Dir[Rails.root + "factories/*.rb"].each do |file|
  puts "Loading: " + file
  require file
end