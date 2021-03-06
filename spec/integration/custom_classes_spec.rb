require "spec_helper"

describe "custom classes" do
  before do
    class User
      extend Rubylog::Context
      predicate ".girl .boy"

      attr_reader :name
      def initialize name
        @name = name
      end
      
      U.girl.if { U.name =~ /[aeiouh]$/ }
      U.boy.unless U.girl

      def long_hair?
        girl?
      end

      def hello
        "Hello #{U.is(self).and(U.girl).true? ? "Ms." : "Mr."} #{@name}!"
      end


    end
  end

  it "can have ruby predicates" do
    john = User.new "John"
    john.girl?.should be_false
    john.boy?.should be_true
    john.long_hair?.should be_false

    jane = User.new "Jane"
    jane.girl?.should be_true
    jane.boy?.should be_false
    jane.long_hair?.should be_true
  end
  
  it "can be used in assertions" do
    pete = User.new "Pete"
    pete.boy?.should be_false
    pete.boy!
    pete.boy?.should be_true

    janet = User.new "Janet"
    janet.girl?.should be_false
    janet.girl!
    janet.girl?.should be_true
  end

  it "can use variables in instance methods" do
    User.new("John").hello.should == "Hello Mr. John!"
    User.new("Jane").hello.should == "Hello Ms. Jane!"
  end




end
