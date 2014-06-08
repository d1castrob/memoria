Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'b1BcFmbc1ILHAcVbhNKyg', 'T7JUvNcTu3RvJ12RRmRkdnaccpH8RDmrZwFR2AY'
  provider :facebook, 'FACEBOOK_ID', 'FACEBOOK_SECRET'
end