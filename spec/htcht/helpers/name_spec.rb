require 'spec_helper'

describe Htcht::Helpers::Name do

  describe 'converting to snake_case' do

    it 'converts CamelCase to snake_case' do
      expect(
        described_class.new("HelloWorld").snake_case
      ).to match /hello_world/
    end

    it 'converts space separated words to snake case' do
      expect(
        described_class.new("Hello World").snake_case
      ).to match /hello_world/
    end

    it 'converts multiple space separated words to snake case' do
      expect(
        described_class.new("Hello    World").snake_case
      ).to match /hello_world/
    end

    it 'converts CamelCase words with numerals' do
      expect(
        described_class.new("Hello1World").snake_case
      ).to match /hello1_world/
    end

    it 'converts space space separated words with numerals' do
      expect(
        described_class.new("Hello 1 World").snake_case
      ).to match /hello_1_world/
    end

    it 'converts kebab case to snake_case' do
      expect(
        described_class.new("hello-world").snake_case
      ).to match /hello_world/
    end
  end
end
