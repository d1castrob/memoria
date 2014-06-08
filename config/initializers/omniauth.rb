Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['1452788382-xdS7HJtMwu7G5chgPB6NyOudzfs9ZAOzaHXzxPQ'], ENV['JwDtgh8Ucmo6DoZeXtcrYEiluvm1Qn2BEB91HPhTo']
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
end