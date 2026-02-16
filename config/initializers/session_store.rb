Rails.application.config.session_store :cookie_store,
  key: '_rails_case_session',
  same_site: :lax,
  secure: false
