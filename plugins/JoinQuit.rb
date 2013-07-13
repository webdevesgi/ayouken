class Cinch::User
  attr_accessor :pv
  def init_game
    @pv = 50
  end
end

class JoinQuit
  include Cinch::Plugin

  listen_to :leaving, method: :on_leaving
  listen_to :join,    method: :on_join

  def on_join(m)
    m.user.init_game
  end

  def on_leaving(m, user)
    if m.channel?
      Channel(m.channel).send("Oh... #{m.user} just left.")
    else
      Channel('#webdevesgi').send("Oh... #{m.user} just left.")
    end
  end
end