
require 'web'
require 'app'

map "/" do
  run App 
end

#require 'app/jobs/scheduling'
#require 'app/messaging/messaging'