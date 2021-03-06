module Rubylog
  class Variable

    # data structure

    attr_reader :name
    def initialize name = :"_#{object_id}"
      @name = name 
      @bound = false
      @dont_care = !!(name.to_s =~ /^(?:ANY|_)/i)
      @guards = []
    end

    def bound?
      @bound
    end

    def inspect
      return "#{@name}=#{@value.inspect}" if @bound

      if @guards.empty?
        @name.to_s
      else
        "#{@name}#{@guards.inspect}"
      end
    end


    def == other
      Variable === other and @name == other.name
    end

    def eql? other
      Variable === other and @name == other.name
    end



    def value
      @value if @bound
    end

    def dont_care? 
      @dont_care
    end

    # Term methods

    # rubylog_clone stays as is
    
    def rubylog_variables
      [self]
    end

    # Unifies the receiver with another value.
    #
    # First dereferences both the receiver and the other. If both dereferenced
    # values are variables, unifies them with the other being bound to the
    # receiver. If one of them is a variable, it gets bound to the other value.
    # If none of them is a variable, they are checked for equality with eql?.
    # Succeeds if other is the same object as the receiver.
    #
    def rubylog_unify other
      # check if we are bound
      if @bound
        # if we are bound
        # proceed to our dereferenced value
        rubylog_dereference.rubylog_unify(other) do yield end
      else
        # if we are unbound
        
        # dereference the other
        other = other.rubylog_dereference

        # if the other is a variable
        if other.is_a? Rubylog::Variable
          # succeed if same object
          (yield; return) if self.equal? other

          # we union our guards with the other's
          other.append_guards guards do
            # and bind to the other
            bind_to other do
              yield
            end
          end
        else
          # if the other is a value
          # bind to it and 
          bind_to other do
            # check our guards
            if guards.all? {|g|g.rubylog_matches_as_guard? other}
              yield
            end
          end
        end
      end
    end


    def rubylog_dereference
      if @bound
        @value.rubylog_dereference
      else
        self
      end
    end

    def rubylog_deep_dereference
      if @bound
        @value.rubylog_deep_dereference
      else
        self
      end
    end

    # Goal methods
    include Goal

    def prove
      v = rubylog_dereference
      raise Rubylog::InstantiationError.new(self) if v.is_a? Rubylog::Variable

      # match variables if not matched
      unless v.rubylog_variables
        v = v.rubylog_match_variables
      end

      caught_cut = false

      catch :rubylog_cut do
        v.prove do
          # intercept cuts that come from the yield
          catch :rubylog_no_cut do
            catch :rubylog_cut do
              yield
              throw :rubylog_no_cut
            end
            caught_cut = true
          end
          break if caught_cut
        end
      end

      # pass through cut if one was caught from yield
      throw :rubylog_cut if caught_cut
    end


    # Array splats
    def to_a
      [Rubylog::DSL::ArraySplat.new(self)]
    end
    alias to_ary to_a

    # String variables
    def to_s
      if @guards.empty?
        "#{String::RUBYLOG_VAR_START}#{@name}[]#{String::RUBYLOG_VAR_END}"
      else
        String::RubylogStringVariableGuards << @guards
        guard_index = String::RubylogStringVariableGuards.length-1
        "#{String::RUBYLOG_VAR_START}#{@name}[#{guard_index}]#{String::RUBYLOG_VAR_END}"
      end
    end

    # guards
    def [] *guards
      @guards += guards
      self
    end

    attr_reader :guards
    attr_writer :guards


    protected

    # yields with self bound to the given value
    def bind_to other
      begin
        @bound = true; @value = other

        yield
      ensure
        @bound = false
      end
    end
    rubylog_traceable :bind_to

    def bind_to! other
      @bound = true; @value = other
      self
    end
    private :bind_to!

    # yields with self.guards = self.guards + other_guards, then restores guards
    def append_guards other_guards
      original_guards = @guards

      @guards = @guards + other_guards

      begin
        yield
      ensure
        @guards = original_guards
      end
    end



  end


end
