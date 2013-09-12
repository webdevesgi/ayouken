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
  match(/pv (.+)/,         method: :execute_pv)
  match(/attack (.+)/,     method: :execute_attack)
  match 'roulette',        method: :execute_roulette
  match 'techniques',      method: :execute_techniques
  match(/slap (.+)/,       method: :execute_slap)
  match(/doubleslap (.+)/, method: :execute_doubleslap)
  match(/tack (.+)/,       method: :execute_tackle)

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

  def execute_techniques(m)
    list = [
      '!slap [user]       ➤ 15 pv/hit',
      '!doubleslap [user] ➤ 30 pv/hit',
      '!tackle [user]     ➤ 20 pv/hit'
    ]
    m.reply list.join("\n")
  end

  def execute_slap(m, username)
    hit 'slap', 15, m, username
  end

  def execute_doubleslap(m, username)
    hit 'doubleslap', 30, m, username
  end

  def execute_tackle(m, username)
    hit 'tackle', 20, m, username
  end

  def hit(technique, pp, m, username)
    username = username.strip
    exists = m.channel.user_is_logged?(username)
    if exists
      from = m.user
      to = m.channel.get_user_from_username(username)
      to.pv -= pp
      m.reply "#{from.nick} hits #{to.nick} with #{technique}"
    else
      m.reply "Can't hit not logged user"
    end
  end

  def execute_roulette(m)
    bullet = 5
    roulette = Random.rand(6)
    res = bullet == roulette ? 'BANG!' : 'Click!'
    m.reply m.user.nick + ' ➤ ' + res
  end
end