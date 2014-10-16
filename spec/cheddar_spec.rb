require 'minitest/autorun'

require_relative '../lib/cheddar'

Cheddar.config(&:cheddarize)

describe :human_to_number do

  it 'should convert integers' do
    '5'.human_to_number.must_equal(5)
    '10'.human_to_number.must_equal(10)
  end

  it 'should handle floats' do
    '5.5'.human_to_number.must_equal(5.5)
    '10.5'.human_to_number.must_equal(10.5)
  end

  it 'should handle hundred' do
    '5 hundred'.human_to_number.must_equal(500)
  end

  it 'should handle thousand' do
    '5 thousand'.human_to_number.must_equal(5000)
  end

  it 'should handle million' do
    '5 million'.human_to_number.must_equal(5_000_000)
  end

  it 'should handle decimals before million' do
    '5.5 million'.human_to_number.must_equal(5_500_000)
  end

  it 'should strip out unknown entities' do
    '5.5 & thousand'.human_to_number.must_equal(5500)
    '5,500'.human_to_number.must_equal(5500)
  end

  it 'should handle up to vigintillion' do
    '3.2 vigintillion'.human_to_number.must_equal(3.2 * 10**63)
  end

  it 'should like money' do
    '$5.2 million'.human_to_number.must_equal(5_200_000)
    '10 large'.human_to_number.must_equal(10_000)
    '10 large'.human_to_number.must_equal('10 big ones'.human_to_number)
  end

  it 'should allow custom configuration' do
    Cheddar.config { |c| c.dialect(:slang_us) { |d| d.define :blings, 100 } }
    '10 blings'.human_to_number.must_equal(1000)
  end

  it 'should support GB slang' do
    '10 bag'.human_to_number.must_equal(10_000)
  end

end
