module SessionsHelper
  def log_in(admin)
    session[:admin_id]=admin.id
  end

  def set_country(country)
    session[:country]=country
  end

  def get_country
    session[:country]
  end

  def current_user
    @current_user ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:admin_id)
    @current_user = nil
  end
end
