require 'cgi'

class Google
  include Cinch::Plugin

  set :prefix, //
  match(/google (.+)/)

  def execute(m, query)
    m.reply "http://www.google.com/search?q=#{CGI.escape(query)}"
  end
end