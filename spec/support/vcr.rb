VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :fakeweb
  # c.filter_sensitive_data('<WSDL>') { "http://www.webservicex.net:80/uszip.asmx?WSDL" }
end