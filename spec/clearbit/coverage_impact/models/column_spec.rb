# frozen_string_literal: true

RSpec.describe Clearbit::CoverageImpact::Column do
  describe "#csv_name" do
    it 'returns the name of the column' do
      column = Clearbit::CoverageImpact::Column.new(name: 'state', value: 'Texas', type: 'before')

      expect(column.csv_name).to eq('before_state')
    end
  end
end
