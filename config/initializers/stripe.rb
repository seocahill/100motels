if Rails.env == "production"
  # set credentials from ENV hash
  stripe = {"app_id" => ENV['STRIPE_PUBLIC_KEY'], "secret" => ENV['STRIPE_API_KEY'], "client" => ENV['STRIPE_PLATFORM_CLIENT_ID']}
else
  # get credentials from YML file
  stripe = YAML.load(File.open(Rails.root.join("config/stripe.yml")))
end

Stripe.api_key = stripe["secret"]
STRIPE_PUBLIC_KEY = stripe["app_id"]
ENV['STRIPE_PLATFORM_CLIENT_ID'] = "ca_0Qb67hX8UIxDZqR1h7De7OPt0UMe0cRH"
ENV['STRIPE_API_KEY'] = "YPB5mXrlxEByHnGwBN7c34gKFXOwVWhb"