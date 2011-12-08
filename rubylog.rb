# rubylog.rb -- Prolog workalike for Ruby
# github.com/cie/rubylog

# rtl
require 'set'

# interfaces
require 'rubylog/term.rb'
require 'rubylog/callable.rb'
require 'rubylog/unifiable.rb'
require 'rubylog/composite_term.rb'

# helpers
require 'rubylog/dsl.rb'
require 'rubylog/dsl/constants.rb'

# classes
require 'rubylog/errors.rb'
require 'rubylog/predicate.rb'
require 'rubylog/theory.rb'
require 'rubylog/variable.rb'

require 'rubylog/builtins.rb'

require 'rubylog/clause.rb'
require 'array.rb'
require 'symbol.rb'
require 'proc.rb'
require 'object.rb'
require 'class.rb'

