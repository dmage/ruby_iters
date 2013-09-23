require 'stdlib'

#begin
log_file = TextFile.new('./some.log')
display(log_file)
display(extract(log_file, /([0-9]+)/))
#end

run
