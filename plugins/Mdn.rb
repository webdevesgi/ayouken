require 'cgi'

class Mdn
  include Cinch::Plugin

  match(/mdn (.+)/)

  def execute(m, query)
    m.reply "https://developer.mozilla.org/en/search?q=#{CGI.escape(query)}"
  end
end