class Other
  include Cinch::Plugin
  match 'forkme', method: :execute_forkme

  def execute_forkme(m)
    m.reply 'https://github.com/webdevesgi/ayouken'
  end
end