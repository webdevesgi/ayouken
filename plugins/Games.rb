class Cinch::Channel
  def user_is_logged?(username)
    exists = false
    @users.each do |u|
      user = u.to_a.first.to_s
      if username == user
        exists = true
        break
      end
    end
    exists
  end

  def get_user_from_username(username)
    @users.each do |u|
      user = u.to_a.first.to_s
      if username == user
        return u.first
      end
    end
  end
end

class Games
  include Cinch::Plugin
  match(/pv (.+)/,     method: :execute_pv)
  match(/attack (.+)/, method: :execute_attack)
  match 'roulette',    method: :execute_roulette

  def execute_pv(m, username)
    username = username.strip
    if m.channel.user_is_logged?(username)
      user = m.channel.get_user_from_username(username)
      if user.is_a?(Cinch::User)
        m.reply "#{user.nick}'s pvs: #{user.pv}"
      else
        m.reply "#{user.nick} is not a player"
      end
    else
      m.reply "This user is not logged."
    end
  end

  def execute_attack(m, username)
    username = username.strip
    exists = m.channel.user_is_logged?(username)
    res = exists ? "#{m.user} kicks #{username}'s ass" : "This user is not logged."
    m.reply res
  end

  def execute_roulette(m)
    bullet = 5
    roulette = Random.rand(6)
    m.reply (bullet == roulette ? "BANG!" : "Click!")
  end
end