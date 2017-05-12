require 'spec_helper'

describe Htcht::Helpers::NameHelpers do
  subject do
    extend(described_class)
  end

  describe 'converting to snake_case' do
    it 'converts CamelCase to snake case' do
      expect(subject.snake_casify('HelloWorld')).to match(/hello_world/)
    end

    it 'converts space separated words to snake case' do
      expect(subject.snake_casify('Hello World')).to match(/hello_world/)
    end

    it 'converts multiple space separated words to snake case' do
      expect(subject.snake_casify('Hello    World')).to match(/hello_world/)
    end

    it 'converts CamelCase words with numerals to snake case' do
      expect(subject.snake_casify('Hello1World')).to match(/hello1_world/)
    end

    it 'converts space space separated words with numerals to snake case' do
      expect(subject.snake_casify('Hello 1 World')).to match(/hello_1_world/)
    end

    it 'converts kebab case to snake case' do
      expect(subject.snake_casify('hello-world')).to match(/hello_world/)
    end
  end
end
