class Video < ActiveRecord::Base
  acts_as_video :vimeo, :youtube
end

class VimeoVideo < ActiveRecord::Base
  acts_as_video :vimeo
end