$:.unshift File.dirname(__FILE__)+"/../lib"
require 'rubylog'

theory do
  functor_for Integer, :divides

  check { A.is_a? Rubylog::Variable }
  check { A.rubylog_deep_dereference == A }
  a = A
  a.rubylog_unify(4) do
    check { a.rubylog_deep_dereference == 4 }
    check { [1,a].rubylog_deep_dereference == [1,4] }
    check { a.divides(16).rubylog_deep_dereference == 4.divides(16) }
  end
end


