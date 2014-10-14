require 'spike/relation'
require 'spike/result'

module Spike
  class AssociationProxy < Relation

    def initialize(owner, name:, **options)
      @owner, @name = owner, name
      @klass = (options[:class_name] || @name.to_s).classify.constantize
      @params = { owner_key => @owner.try(:id) }
    end

    def collection_path
      "#{@owner.class.base_path}/:#{owner_key}#{klass.collection_path}"
    end

    private

      def fetch(path)
        fetch_embedded || super
      end

      def fetch_embedded
        Result.new(data: embedded_result) if embedded_result
      end

      def embedded_result
        @owner.attributes[@name]
      end

      def owner_key
        "#{@owner.class.model_name.param_key}_id"
      end

  end
end