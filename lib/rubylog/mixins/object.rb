class Object
  include Rubylog::Term

  def rubylog_matches_as_guard? other
    Rubylog.print_trace 0, "#{inspect}===#{other.inspect}"
    self === other
  end
end
