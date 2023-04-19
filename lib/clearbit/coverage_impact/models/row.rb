require 'shale'
require_relative 'column'

module Clearbit
  module CoverageImpact
    class Row < Shale::Mapper
      attribute :id, Shale::Type::Integer
      # Unique row identifier
      attribute :urid, Shale::Type::String
      attribute :columns, Column, collection: true

      # Meta programming alert
      #
      def method_missing(method, *args)
        super unless column_csv_names.include?(method.to_s)

        column_type = nil
        if %w[before after].include?(method.to_s.split('_').first)
          column_type = method.to_s.split('_').first.to_s
        end

        columns.select do |column|
          column_name = method.to_s.gsub('after_', '').gsub('before_', '')
          column.name == column_name && column.type == column_type
        end.first
      end

      private

      def column_csv_names
        columns.map do |column|
          column.csv_name
        end.uniq.compact
      end
    end
  end
end
