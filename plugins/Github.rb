require 'octokit'

class Github
  include Cinch::Plugin

  set :prefix, //
  match(/https:\/\/github.com\/(.+)\/(.+)/)

  def execute(m, user_name, repo_name)
    repo = Octokit.repo :username => user_name, :repo => repo_name
    repo_commits = Octokit.commits("#{user_name}/#{repo_name}")
    res = [
      "#{repo.name}" + (repo.description.empty? ? '' : ": #{repo.description}"),
      "forks: #{repo.forks}",
      "commits: #{repo_commits.size}",
      "watchers: #{repo.watchers}"
    ]
    res.push "language: #{repo.language}" unless repo.language.nil?
    m.reply res.join(' | ')
  end
end