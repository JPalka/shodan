# frozen_string_literal: true

module AI
  module Logs
    class FilterQuery
      attr_reader :severity

      def initialize(scope, params)
        @scope = scope
        @params = params.to_h.compact

        @severity = @params.delete(:severity)
        @page = @params.delete(:page)
        @per_page = @params.delete(:per_page)
      end

      def call
        result = @scope.where(@params)
        result = filter(result)
        [paginate(order(result)), result.count]
      end

      private

      def order(scope)
        scope.order(:created_at.desc)
      end

      def filter(scope)
        final_filter = method(:filter_by_severity)
        final_filter.call(scope)
      end

      def paginate(scope)
        scope.page(@page || 1).per(@per_page || 10)
      end

      def filter_by_severity(scope)
        if severity.present?
          scope.where(severity: severity)
        else
          scope
        end
      end
    end
  end
end
