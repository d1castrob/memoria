Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'Ze6uAgUGLBYmUerv8iHEZmK9P', 'cBtKADamQzPsaLd0kXtrnkDlH6T6kIOnbK5FudZ6PkYqfWFQiu'#, {:client_options => {:ssl => {:verify => false}}}
  provider :facebook, '625306310826804', '166ce5139e058e48c51328bcfb61eaa6'
end