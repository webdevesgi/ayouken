# encoding: UTF-8

class Doc
  include Cinch::Plugin
  match "commands"

  def list
    [
      "google [query]                   ➤ Get link to Google query",
      "https://twitter.com/[tweet-url]  ➤ Display tweet",
      "https://github.com/[user]/[repo] ➤ Get Github repository information",
      "!mdn [query]                     ➤ Search on Mozilla Developer Network",
      "!attack [nick]                   ➤ Kick [nick]'s ass",
      "!pv [nick]                       ➤ Get [nick]'s pvs",
      "!techniques                      ➤ Get all available moves",
      "!roulette                        ➤ 1 chance out of 6 to die",
      "!fact                            ➤ Get random world fact",
      "!gif                             ➤ Get random gif from top reddit /r/gifs",
      "!sexygif                         ➤ Get random gif from top reddit /r/randomsexygifs",
      "!porn                            ➤ Get random img from top reddit /r/porn",
      "!forkme                          ➤ Get URL of repo",
      "!commands                        ➤ List of bot's commands"
    ]
  end

  def execute(m)
    m.reply list.join("\n")
  end
end