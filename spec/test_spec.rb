class Test

  def grade
    9
  end
end

RSpec.describe Test do
  describe '#grade' do
    it 'returns de grade' do
      expect(subject.grade).to be <= 10 
    end
  end
end