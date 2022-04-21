class Terraspace::Cloud::Ci
  class Manual
    extend Memoist

    def vars
      git = Git.new
      provider_class = case git.host
                       when /github/
                         Github
                       when /gitlab/
                         Gitlab
                       when /bitbucket/
                         Bitbucket
                       end
      provider_class ? provider_class.new.vars : {}
    end
  end
end
