module Terraspace::Cloud
  module Context
    def setup_context(options)
      cloud = Terraspace.config.cloud
      @org = cloud.org
      @project = cloud.project
      @env = options[:env] || Terraspace.env
      @stack = options[:stack]
    end
  end
end
