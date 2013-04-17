require "rubylog"
extend Rubylog::Context

predicate_for String, "FILE.found_in(DIR)"

FILE.found_in(DIR).if FILE.file_in(DIR)
FILE.found_in(DIR).if DIR2[thats_not.start_with(".")].dir_in(DIR).and FILE.found_in(DIR2)

FILE.found_in(".").each do
  puts FILE
end



