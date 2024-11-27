# frozen_string_literal: true

SecureHeaders::Configuration.default do |config|
  config.csp = {
    default_src: ["'self'"],
    script_src: ["'self'", "'unsafe-inline'"], # Allow scripts from self or inline
    style_src: ["'self'", "'unsafe-inline'"], # Allow inline styles
    img_src: ["'self'", 'data:'], # Allow self-hosted images and base64
    connect_src: ["'self'"],
    font_src: ["'self'", 'https:'],
    object_src: ["'none'"], # Disallow plugins
    frame_ancestors: ["'none'"] # Disallow embedding
  }
end
