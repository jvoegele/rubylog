require 'spec_helper'

describe Array, :rubylog=>true do

  describe "unification" do
    def can_unify a, b
      result = false
      a.rubylog_unify(b) { result = true; yield if block_given? }
      result.should == true
    end

    def cannot_unify a, b
      result = false
      a.rubylog_unify(b) { result = true }
      result.should == false
    end

    it "does not unify with non-array" do
      cannot_unify [A,B], 12
    end

    it "unifies empty arrays" do
      can_unify [], []
    end

    it "unifies empty array with splat" do
      a = A
      can_unify [], [*a] do
        a.value.should == []
      end
    end

    it "unifies two splats" do
      a = A
      b = B
      can_unify [*a], [*b] do
        a.instance_variable_get(:"@value").should == b
      end
    end

  end
end
