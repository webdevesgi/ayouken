require 'nokogiri'
require 'open-uri'

class Reddit
  def get_links(url)
    res = Nokogiri::HTML(open(url, "Cookie" => "over18=1")).css('a.title')
    rand = Random.rand(res.size)
    link = res[rand]
    "#{link.content} #{link[:href]}"
  end
end

class RedditGif < Reddit
  include Cinch::Plugin
  match "gif", method: :execute_gif

  def execute_gif(m)
    m.reply get_links('http://www.reddit.com/r/gifs')
  end
end