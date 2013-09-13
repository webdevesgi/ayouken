require 'nokogiri'
require 'open-uri'

class Twitter
  include Cinch::Plugin

  set :prefix, //
  match(/https:\/\/twitter.com\/(.+)\/status\/(.+)/, method: :execute_tweet)
  match(/https:\/\/twitter.com\/(.+)/,               method: :execute_account)

  def execute_tweet(m, account, id)
    url = "https://twitter.com/#{account}/status/#{id}"
    document = Nokogiri::HTML(open(url))

    tweet = document.css('.opened-tweet .tweet-text')[1]
    author = document.css('.opened-tweet .js-action-profile-name').last.content
    contains_img = false

    tweet.css('a').each do |link|
      unless link.attributes['data-expanded-url'].nil?
        link.content = link.attributes['data-expanded-url']
      end
      unless link.attributes['data-pre-embedded'].nil? # Contains an image
        link.content = link.attributes['href']
        contains_img = true
      end
    end

    m.reply((contains_img ? "[img] " : "") + "#{author}: #{tweet.text}")
  end

  def execute_account(m, account)
    url = "https://twitter.com/#{account}"
    document = Nokogiri::HTML(open(url)).css('.profile-card-inner')

    real_name_container = document.css('h1 .profile-field')
    username_container = document.css('h2 .screen-name')
    bio_container = document.css('.bio-container .bio')
    res = ""

    unless real_name_container.nil?
      res << real_name_container.first.content
    end

    unless username_container.nil?
      if real_name_container.nil?
        res << real_name_container.first.content
      else
        res << ' (' + username_container.first.content + ')'
      end
    end

    unless bio_container.nil? || bio_container.first.content.empty?
      res << ': ' + bio_container.first.content
    end

    m.reply res
  end
end