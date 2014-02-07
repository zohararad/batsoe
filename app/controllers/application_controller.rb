class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :search_engine?

  def search_engine?
    user_agent = request.user_agent.downcase
    bot_strings = 'msnbot|googlebot|alexa|bot|crawl(er|ing)|facebookexternalhit|feedburner|google web preview|nagios|postrank|pingdom|slurp|spider|yahoo!|yandex'
    @_se ||= user_agent.match(/\(.*https?:\/\/.*\)/i) || user_agent.match(/#{bot_strings}/i) || params[:se] == '1'
  end
end
