# frozen_string_literal: true

# This module gives users the ability to add a row to their comparison data
# during algorithms or while iterating over output data
module Clearbit
  module CoverageImpact
    module Storable
      def add_after_row
        data_point_variables.each do |var|
          current_row.create_column(
            data_point_name: var,
            value: instance_variable_get("@#{var}"),
            type: :after
          )
        end
      end

      def add_before_row
        data_point_variables.each do |var|
          current_row.create_column(
            data_point_name: var,
            value: instance_variable_get("@#{var}"),
            type: :before
          )
        end
      end

      private

      def current_row
        row_id = instance_variable_get("@row_id")
        urid = instance_variable_get("@urid")
        @current_row = data.find_or_create_row(id: row_id, _urid: urid)
      end
    end
  end
end
