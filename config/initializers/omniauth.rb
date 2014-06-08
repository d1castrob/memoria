Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'b1BcFmbc1ILHAcVbhNKyg', 'T7JUvNcTu3RvJ12RRmRkdnaccpH8RDmrZwFR2AY'
  provider :facebook, '625306310826804', '166ce5139e058e48c51328bcfb61eaa6'
end