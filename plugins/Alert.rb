class Cinch::Channel
  def get_usernames
    users = []
    @users.each do |u|
      user = u.to_a.first.to_s
      users << user
    end
    users
  end
end

class Alert
  include Cinch::Plugin
  match(/alert (.+)/, method: :execute_alert)

  def execute_alert(m, message)
    usernames = m.channel.get_usernames
    usernames.delete('ChanServ') # Remove ChanServ
    usernames.delete(m.bot.nick) # Remove bot
    m.reply message + '   // poke ' + usernames.join(' ')
  end
end