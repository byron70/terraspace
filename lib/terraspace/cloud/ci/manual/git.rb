class Terraspace::Cloud::Ci::Manual
  class Git
    extend Memoist
    include Terraspace::Util::Logging

    def host
      return nil unless File.exist?('.git')
      return nil if git_url.blank?
      uri = URI(git_url)
      "#{uri.scheme}://#{uri.host}"
    end

    def full_repo
      uri = URI(git_url)
      uri.path.sub(/^\//,'')
    end

    def dirty?
      out = git "status --porcelain"
      !out.blank?
    end

    # Works for
    #   git@github.com:    => https://github.com/
    #   git@bitbucket.org: => https://bitbucket.org/
    #   git@gitlab.com:    => https://gitlab.com/
    def git_url
      out = git "config --get remote.origin.url"
      out.sub(/\.git/,'').sub(/^git@/,'https://').sub(/\.(.*):/,'.\1/')
    end

    def branch_name
      out = git "rev-parse --abbrev-ref HEAD"
      out unless out == "HEAD" # edge case: when branch has never been pushed
    end

    def sha
      out = git "rev-parse HEAD"
      out unless out == "HEAD" # edge case: when branch has never been pushed
    end

    def git(command)
      return unless git_installed?
      out = `git #{command}`
      unless $?.success?
        logger.debug "WARN Command Failed: git #{command}".color(:yellow)
      end
      out.strip
    end
    memoize :git

    def git_installed?
      system "type git > /dev/null 2>&1"
    end
  end
end
