require 'nokogiri'
require 'open-uri'

class Fact
  include Cinch::Plugin
  match 'fact'

  def execute(m)
    url = 'http://randomfunfacts.com'
    res = Nokogiri::HTML(open(url)).css('#AutoNumber1 i').first.content.strip
    m.reply res
  end
end