module Terraspace::Cloud
  class Api
    include Context
    include HttpMethods

    def initialize(options)
      @options = options.merge(env: Terraspace.env) # @options are CLI options
      setup_context(@options)
    end

    def endpoint
      ENV['TS_API'] || 'https://api.terraspace.cloud/api/v1'
    end

    def stack_path
      "orgs/#{@org}/projects/#{@project}/stacks/#{@stack}"
    end

    def create_upload
      post("#{stack_path}/uploads", @options)
    end

    # record_attrs: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_plan(data)
      post("#{stack_path}/plans", data)
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_update(data)
      post("#{stack_path}/updates", data)
    end
  end
end
