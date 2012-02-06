require 'human_to_number'

String::SLANG_ENABLED = true

describe :human_to_number do

  it "should convert integers" do
    '5'.human_to_number.should eq(5)
    '10'.human_to_number.should eq(10)
  end

  it "should handle floats" do
    '5.5'.human_to_number.should eq(5.5)
    '10.5'.human_to_number.should eq(10.5)
  end

  it "should handle hundred" do
    '5 hundred'.human_to_number.should eq(500)
  end

  it "should handle thousand" do
    '5 thousand'.human_to_number.should eq(5000)
  end

  it "should handle million" do
    '5 million'.human_to_number.should eq(5000000)
  end
  
  it "should handle decimals before million" do
    '5.5 million'.human_to_number.should eq(5500000)
  end

  it "should strip out unknown entities" do
    '5.5 & thousand'.human_to_number.should eq(5500)
    '5,500'.human_to_number.should eq(5500)
  end

  it "should handle up to vigintillion" do
    '3.2 vigintillion'.human_to_number.should eq(3.2 * 10**63)
  end

  it "should like money" do
    '$5.2 million'.human_to_number.should eq(5200000)
    '10 large'.human_to_number.should eq(1000)
  end

end
