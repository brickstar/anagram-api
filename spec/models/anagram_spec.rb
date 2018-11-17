require 'rails_helper'

RSpec.describe Anagram, type: :model do
  describe 'Relationships' do
    it { should have_many(:words) }
  end
end
