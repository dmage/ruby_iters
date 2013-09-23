require 'stdlib'

#begin
log_file = TextFile.new("./some.log")
display(log_file)
display(extract(log_file, /([0-9]+)/))

timer = Timer.new(2)
display(timer)

w_output = replace_by_program_output(timer, "env LANG=C /usr/bin/w")
load_avg = to_float(extract(w_output, /load average: ([0-9.]+)/))

display(load_avg)
display(subtract(load_avg, prev(load_avg)))
#end

run
