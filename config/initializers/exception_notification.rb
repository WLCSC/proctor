Proctor::Application.config.middleware.use ExceptionNotification::Rack,
:email => {
  :email_prefix => "[PROCTOR ERROR] ",
  :sender_address => APP_CONFIG[:email_support_from],
  :exception_recipients => [APP_CONFIG[:email_support_recipients].split(';')]
}
