module I18nHelper

  def set_locale
    # Save locale in session when explicitly specified
    session[:locale] = params[:locale] if params[:locale] and I18n.locale_available?(params[:locale])

    # Locale defaults to HTTP_ACCEPT_LANGUAGE then the default locale
    locale = session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
    I18n.locale = locale || I18n.default_locale
  end

  def set_admin_locale
    I18n.locale = :en
  end
end
