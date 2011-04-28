require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "acts_as_video/acts_as_video"
require "acts_as_video/acts_as_video/core"

require "acts_as_video/hosts/vimeo"  
require "acts_as_video/hosts/youtube"  

$LOAD_PATH.shift

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ActsAsVideo::Video
end