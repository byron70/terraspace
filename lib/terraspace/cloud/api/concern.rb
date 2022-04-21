class Terraspace::Cloud::Api
  module Concern
    include Errors
    include Record

    def api
      Terraspace::Cloud::Api.new(@options) # @options are CLI options
    end
  end
end
