gmail = YAML.load_file("#{::Rails.root}/config/gmail.yml")[::Rails.env]

GMAIL_PASSWORD = gmail["password"]