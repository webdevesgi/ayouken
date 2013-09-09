class Alert
  include Cinch::Plugin
  match(/alert (.+)/, method: :execute_alert)

  def execute_alert(m, message)
    m.reply message + ' poke ' + m.channel.get_usernames.join(' ')
  end
end