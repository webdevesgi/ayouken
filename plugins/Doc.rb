# encoding: UTF-8

class Doc
  include Cinch::Plugin
  match "commands"

  def list
    [
      "google [query]                  ➤ Get link to Google query",
      "https://twitter.com/[tweet-url] ➤ Display tweet",
      "!attack [nick]                  ➤ Kick [nick]'s ass",
      "!pv [nick]                      ➤ Get [nick]'s pvs",
      "!roulette                       ➤ 1 chance out of 6 to die",
      "!fact                           ➤ Get random world fact",
      "!gif                            ➤ Get random gif from top reddit /r/gifs",
      "!commands                       ➤ List of bot's commands"
    ]
  end

  def execute(m)
    m.reply list.join("\n")
  end
end