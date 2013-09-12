require 'cgi'
require 'nokogiri'
require 'open-uri'

class Google
  include Cinch::Plugin

  match(/google (.+)/)

  def execute(m, query)
    url = "http://www.google.com/search?q=#{CGI.escape(query)}"
    m.reply "#{get_first_result(url)} ( #{url} )"
  end

  def get_first_result(url)
    res = Nokogiri::HTML(open(url)).css('li.g')
    li = res.first
    title = li.css('h3>a').first.content
    link = li.css('.s .kv cite').first.content
    unless link[0..3] == 'http'
      link = "http://#{link}"
    end
    "#{title} #{link}"
  end
end