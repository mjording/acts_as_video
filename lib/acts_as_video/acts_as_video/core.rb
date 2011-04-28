module ActsAsVideo::Video
  module Core
    def self.included(base)
      base.extend ActsAsVideo::Video::Core::ClassMethods
      base.send :include, ActsAsVideo::Video::Core::InstanceMethods
      
      base.initialize_acts_video_core
    end

    module ClassMethods
      def initialize_acts_video_core
        # video_hosts.map(&:to_s).each do
        #   #Include module
        # end
        
        class_eval do
          attr_accessor :url
          #validates_presence_of :url, :on => [:create]          
        end
      end
  
      def acts_as_video(*args)
        super(*args)
        initialize_acts_as_taggable_on_core
      end
      
      def domain_from_url(url)
        matches = /(http:\/\/)?(www.)?([A-Za-z0-9._%-]*)\.com/.match(url)
        matches.nil? ? raise("Invalid Url") : domain = matches[3]        
      end
  
      def class_from_url(url)
        # try to convert the url to a class, if no class exisists, rescue error and raise error
        domain = domain_from_url(url)
        raise "Unsupported Domain" unless video_hosts.include?(domain.to_sym)
        domain_from_url(url).capitalize.constantize rescue raise "Unsupported Domain"
      end  
    end
    
    module InstanceMethods
      def url=(url)
        debugger
        begin
          host = self.class.class_from_url url
        rescue "Unsupported Domain"
          errors.add_to_base "Translation Here"
        rescue "Invalid Url"
          errors.add_to_base "Translation Here"
        end
      end
  
      def embed_url
        raise NotImplementedError, "Can only call #embed_url on a subclass of acts_as_video class"
      end
    end
  end
end



