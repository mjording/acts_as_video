class Video < ActiveRecord::Base
  acts_as_video
end

class VimeoVideo < ActiveRecord::Base
  acts_as_video :video_hosts => [:vimeo]
end