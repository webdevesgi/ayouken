require 'twitter'

  Twitter.configure do |config|
    config.consumer_key = 'KrTk1YVxlXeebkMC3GhWw'
    config.consumer_secret = 'ejgzdOq51Y8RpmoAcDOLJQ1HtK9dxCtOgSuk5NnYnM'
    config.oauth_token = '110743589-7pP2PrPNYnXAbySWoGG06jArtugVpLCUNgVLEBkK'
    config.oauth_token_secret = 'XNWccKad10yYVVuyWH0dSgYrXJaDT4kC0HyXtsQwMY'
  end

class HashTag
  include Cinch::Plugin

  match 'test', method: :test
  def test(m)
    res = Twitter.search("#ruby -rt").statuses
    m.reply res
  end
end
