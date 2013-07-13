# Gem deps
require 'cinch'

# Include plugins
plugins_dir = File.dirname(__FILE__) + '/plugins/'
require plugins_dir + 'JoinQuit'
require plugins_dir + 'Games'
require plugins_dir + 'Google'
require plugins_dir + 'Fact'
require plugins_dir + 'Tweet'
require plugins_dir + 'Github'
require plugins_dir + 'Reddit'
require plugins_dir + 'Doc'



bot = Cinch::Bot.new do
  configure do |c|
    c.encoding        = 'utf-8'
    c.server          = "irc.freenode.org"
    c.nick            = "ayouken"
    c.user            = "ayouken"
    c.channels        = ['#webdevesgi']
    c.plugins.plugins = [
      JoinQuit,
      Games,
      Google,
      Fact,
      Tweet,
      Github,
      RedditGif,
      Doc
    ]
  end
end

bot.start
