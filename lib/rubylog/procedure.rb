module Rubylog
  class Procedure < Predicate
    include Enumerable

    # accepts the *args of the called structure
    def call *args
      # catch cuts
      catch :cut do

        # for each rule
        each do |rule|
          begin

            # compile
            rule = rule.rubylog_compile_variables
            Rubylog.print_trace 1, rule.head.args, "=", args

            # unify the head with the arguments
            rule.head.args.rubylog_unify(args) do
              begin
                Rubylog.print_trace 1, rule.head, rule.head.rubylog_variables_hash

                # call the body
                rule.body.prove do
                  yield 
                end
              ensure
                Rubylog.print_trace -1
              end
            end
          ensure
            Rubylog.print_trace -1
          end
        end
      end
    end

    def each
      raise "abstract method called"
    end

    # Asserts a rule with a given head and body.
    def assert head, body=:true
      push Rubylog::Rule.new(head, body)
    end

  end
end
