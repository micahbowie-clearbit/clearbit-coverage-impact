# frozen_string_literal: true

RSpec.describe Clearbit::CoverageImpact::Analyze do
  # This is testing the meta programming of the Row class
  # That allows .column_name_here be called on the row and return the column
  describe '#run' do
    context 'when data is an empty hash' do
      it 'returns an empty array' do
        expect(Clearbit::CoverageImpact::Analyze.run({})).to eq([])
      end
    end

    context 'when data is an empty array' do
      it 'returns an empty array' do
        expect(Clearbit::CoverageImpact::Analyze.run([])).to eq([])
      end
    end

    context 'when data is nil' do
      it 'returns an empty array' do
        expect(Clearbit::CoverageImpact::Analyze.run(nil)).to eq([])
      end
    end

    context 'when given valid data' do
      it 'returns an analyzation' do  
        
      end
    end
  end
end
