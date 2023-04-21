# frozen_string_literal: true
require 'hashie'

module Clearbit
  module CoverageImpact
    # Clearbit::CoverageImpact:DataTable
    class DataTable < Hash
      include Hashie::Extensions::DeepLocate
      include Hashie::Extensions::DeepMerge
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::IndifferentAccess
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::MethodOverridingInitializer

      def find_or_create_row(id:, _urid: nil)
        self[id] = DataRow.new unless self[id]

        self[id]
      end
      alias rows values
      alias row_count count

      def set_data!(data)
        return unless data.present?

        data.each do |key, row|
          self[key] = DataRow.new(row) unless self[key]

          self[key]
        end
        self
      end
    end

    # Clearbit::CoverageImpact:DataRow
    class DataRow < Array
      include ::Hashie::Extensions::DeepLocate
      include ::Hashie::Extensions::DeepFind

      def create_column(data_point_name:, value:, type:)
        self << DataColumn.new(data_point_name: data_point_name, value: value, type: type)
      end
    end

    # Clearbit::CoverageImpact:DataColumn
    class DataColumn < Hash
      include Hashie::Extensions::MergeInitializer
      include ::Hashie::Extensions::IndifferentAccess
    end

    # Clearbit::CoverageImpact::DataStore
    class DataStore
      attr_reader :raw
      attr_accessor :table

      def initialize(table: nil)
        @raw = []
        @table = table || DataTable.new
      end
    end
  end
end
