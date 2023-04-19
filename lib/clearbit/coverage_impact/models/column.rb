require 'shale'

module Clearbit
  module CoverageImpact
    class Column < Shale::Mapper
      attribute :name, Shale::Type::String
      attribute :value, Shale::Type::Value
      attribute :type, Shale::Type::String

      attr_reader :csv_name

      def initialize(**args)
        super

        @csv_name = type ? "#{type}_#{name}" : name
      end
    end
  end
end
