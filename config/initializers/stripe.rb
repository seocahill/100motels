if Rails.env == "production"
  # set credentials from ENV hash
  stripe = {"app_id" => ENV['STRIPE_PUBLIC_KEY'], "secret" => ENV['STRIPE_API_KEY']}
else
  # get credentials from YML file
  stripe = YAML.load(File.open(Rails.root.join("config/stripe.yml")))
end

Stripe.api_key = stripe["secret"]
STRIPE_PUBLIC_KEY = stripe["app_id"]