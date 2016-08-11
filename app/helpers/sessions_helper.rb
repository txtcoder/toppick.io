module SessionsHelper
  def log_in(admin)
    session[:admin_id]=admin.id
  end

  def set_country(country)
    session[:country]=country
  end

  def get_country
    if session[:country].nil?
        require 'geoip'
        @geoip ||= GeoIP.new("./db/GeoIP.dat")
        remote_ip = request.remote_ip
        if remote_ip != "127.0.0.1" #todo: check for other local addresses or set default value
            location_location = @geoip.country(remote_ip)
            if location_location != nil
                locale = location_location.country_name
            end
        end
        # default everything except for Canada to USA
        if locale && locale == "Canada"
            session[:country]="Canada"
        else
            session[:country]="USA"
        end
    end
    session[:country]
  end

  def get_referral
    if session[:referral].nil?
        if params[:q]
            session[:referral]=params[:q]
        elsif !request.referer.blank?
            if request.referer.include? "facebook"
                session[:referral]="facebook"
            else
                session[:referral]="other"
            end
        else
            session[:referral]="original"
        end
    end
    session[:referral]
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

  def apply_referral(links)
    links.each do |link|
        url = link.url
        res = Affiliate.find_by( domain: link.domain, source: get_referral)
        unless res
            res = Affiliate.find_by( domain: link.domain, source: "original")
        end
         if res
            referral = res.referral
            tag=referral.split("=")[0]
            content=referral.split("=")[1]

            if url.include? tag+"="
                url.gsub(/(#{tag}=).*/, referral)

            elsif url.include? "?" and url[-1]!="/"
                url = url+"&"+referral
            elsif url.include? "?"
                url= url[0..-1]+"&"+referral
            elsif url[-1]!="/"
                url=url+"/?"+referral
            else
                url=url+"?"+referral
            end
        end
        link.url=url
    end

  end

end
