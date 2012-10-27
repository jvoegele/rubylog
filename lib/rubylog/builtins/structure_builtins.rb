Rubylog.theory "Rubylog::StructureBuiltins", nil do
  subject Rubylog::Structure

  class << primitives

    def structure c, fct, args
      c = c.rubylog_dereference
      if c.is_a? Rubylog::Variable
        fct = fct.rubylog_dereference
        args = args.rubylog_dereference
        raise Rubylog::InstantiationError, fct if fct.is_a? Rubylog::Variable
        raise Rubylog::InstantiationError, args if args.is_a? Rubylog::Variable
        c.rubylog_unify(Rubylog::Structure.new(fct, *args)) { yield }
      elsif c.is_a? Rubylog::Structure
        c.functor.rubylog_unify fct do
          c.args.rubylog_unify args do
            yield
          end
        end
      end
    end

  end
end


Rubylog.theory "Rubylog::DefaultBuiltins" do
  include Rubylog::StructureBuiltins
end