class Terraspace::Cloud::Ci::Manual
  class Base
    extend Memoist

    def vars
      {
        build_system: "manual",   # required
        full_repo: full_repo,
        branch_name: branch_name,
        # urls
        commit_url: commit_url,  # implemented by subclass
        branch_url: branch_url,  # implemented by subclass
        # pr_url: pr_url,
        # build_url: build_url,
        # additional properties
        # build_type: build_type,   # required IE: pull_request or push
        # pr_number: pr['number'],  # set when build_type=pull_request
        sha: sha,
        # additional properties
        # commit_message: commit_message,
        # build_id: build_id,
        # build_number: ENV['GITHUB_RUN_NUMBER'],
        dirty: dirty?,
      }
    end

    delegate :host, :full_repo, :branch_name, :sha, :dirty?,
         to: :git

    def git
      Git.new
    end
    memoize :git
  end
end
