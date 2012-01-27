
# Increase the parameter key space security limit to allow large nested forms
# (workaround for 1.3.x rack bug)
Rack::Utils.key_space_limit = 1000000
