#Twitter's plugins
require 'twitter'
require 'nokogiri'
require 'open-uri'
require 'yaml'

def read_config
  twitter_api = YAML.load_file( File.dirname(__FILE__) + '/../config.yml' )
  Twitter.configure do |config|
    config.consumer_key       = twitter_api["twitter_api"]["twitter_consumer_key"]
    config.consumer_secret    = twitter_api["twitter_api"]["twitter_consumer_secret"]
    config.oauth_token        = twitter_api["twitter_api"]["twitter_oauth_token"]
    config.oauth_token_secret = twitter_api["twitter_api"]["twitter_oauth_token_secret"]
  end
end
read_config

class TwitterHashTag
  include Cinch::Plugin

  set :prefix, //
  match /(?:(?<=\s)|^)#(\w*[A-Za-z_]+\w*)/, method: :get_first_tweet

  def get_first_tweet(m, hashtag)
    res = Twitter.search("##{hashtag} -rt")
    text = res.results.map{ |t| ['@' + t.from_user, t.text].join(' ➤ ') }.first

    tiny_url = ''
    long_url = ''

    res.results.first.urls.map do |u|
      tiny_url = u.url
      long_url = u.expanded_url
    end

    m.reply text.gsub(/#{tiny_url}/, long_url)
  end
end

class TwitterScrap
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
