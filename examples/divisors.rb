$:.unshift File.dirname(__FILE__)+"/../lib"
require "rubylog"

# Outputs the number of pairs of divisors of 672

module Divisors
  extend Rubylog::Context
  p rubylog { P.is(672).and A.in{1..P}.and P.product_of(A,B).and{A<=B} }.count
end 
