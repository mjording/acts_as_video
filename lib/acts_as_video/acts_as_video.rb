module ActsAsVideo
  module Video
    def acts_as_video(*video_hosts)
      write_inheritable_attribute(:video_hosts, video_hosts)
      class_inheritable_reader(:video_hosts)
      
      class_eval do
        include ActsAsVideo::Video::Core
      end

    end
    
  end
end
