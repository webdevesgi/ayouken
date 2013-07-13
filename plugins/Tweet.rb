require 'nokogiri'
require 'open-uri'

class Tweet
  include Cinch::Plugin

  set :prefix, //
  match(/https:\/\/twitter.com\/(.+)/)

  def execute(m, query)
    document = Nokogiri::HTML(open('https://twitter.com/' + query))
    tweet = document.css('.opened-tweet .tweet-text')[1]
    author = document.css('.opened-tweet .js-action-profile-name').last.content
    tweet.css('a').each do |link|
      unless link.attributes['data-expanded-url'].nil?
        link.content = link.attributes['data-expanded-url']
      end
    end
    m.reply "#{author}: #{tweet.text}"
  end
end