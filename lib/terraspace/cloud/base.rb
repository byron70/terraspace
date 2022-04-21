module Terraspace::Cloud
  class Base < Terraspace::CLI::Base
    extend Memoist
    include Api::Concern
    include Context
    include Terraspace::Util

    def initialize(options={})
      super
      @success = options[:success]
      @kind = options[:kind]
      setup_context(options)
    end

    def stage_attrs
      status = @success ? "success" : "fail"
      attrs = {
        status: status,
        kind: @kind,
        terraspace_version: check.terraspace_version,
        terraform_version: check.terraform_version,
      }
      attrs.merge!(ci.vars) if ci
      attrs
    end

    def check
      Terraspace::CLI::Setup::Check.new
    end
    memoize :check

    def pr_comment(url)
      ci.comment(url) if ci.respond_to?(:comment)
    end

    def ci
      ci_class = Terraspace::Cloud::Ci.detect
      ci_class.new if ci_class
    end
    memoize :ci

    def sh(command, exit_on_fail: true)
      logger.debug "=> #{command}"
      system command
      if $?.exitstatus != 0 && exit_on_fail
        logger.info "ERROR RUNNING: #{command}"
        exit $?.exitstatus
      end
    end

    def clean_cache2_stage
      # terraform plan can be a kind of apply or destroy
      # terraform apply can be a kind of apply or destroy
      kind = self.class.name.to_s.split('::').last.underscore # IE: apply or destroy
      dir = "#{@mod.cache_dir}/.terraspace-cache/_cache2/#{kind}"
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir)
    end

    def no_changes?
      !!Terraspace::Logger.buffer.detect do |line|
        line.include?('No changes')
      end
    end
  end
end
