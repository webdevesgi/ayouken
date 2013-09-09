require 'cgi'
require File.dirname(__FILE__) + '/Reddit'

class Nsfw < Reddit
  include Cinch::Plugin
  match "sexygif",      method: :execute_sexygif
  match "porn",         method: :execute_porn
  match(/pornhub (.+)/, method: :execute_pornhub)

  def execute_sexygif(m)
    m.reply get_links('http://www.reddit.com/r/randomsexygifs')
  end

  def execute_porn(m)
    m.reply get_links('http://www.reddit.com/r/porn')
  end

  def execute_pornhub(m, query)
    url = "http://www.pornhub.com/video/search?search=#{CGI.escape(query)}"
    res = Nokogiri::HTML(open(url))
    videos = res.css('li.videoblock')
    if videos.any?
      video = videos.first.css('a.img').first
      m.reply "#{video[:title]} - #{video[:href]}"
    else
      m.reply 'No result found.'
    end
  end
end