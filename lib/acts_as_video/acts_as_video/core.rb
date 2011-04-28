require 'net/http'
module ActsAsVideo::Video
  module Core
    def self.included(base)
      base.extend ActsAsVideo::Video::Core::ClassMethods
      base.send :include, ActsAsVideo::Video::Core::InstanceMethods
      
      base.initialize_acts_video_core
    end

    module ClassMethods
      def initialize_acts_video_core        
        attr :url
        validates_presence_of :url, :on => [:create]
        
        self.extend Youtube
        self.extend Vimeo     
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
      
      def initialize_with_url(url)
        video = self.new(:url => url)
        video.set_embed_id_from_url url
        video
      end
      
    end
    
    module InstanceMethods
      def url=(url)
        begin
          domain_class = self.class.class_from_url url          
          self.type = domain_class.to_s
          url.gsub(domain_class::EMBED_ID_REGEX) do
            self.embed_id = $3
          end
          data = response
          self.title = data['title']
          self.thumbnail_url = data['thumbnail_url']
        rescue Exception => ex
          case ex.message          
            when "Unsupported Domain"
              errors.add :base, "Translation Here"
            when "Invalid Url"
              errors.add :base, "Translation Here"
            when "Video doesnt exist"
              errors.add :url, "Translation Here"
            else
              raise ex
          end
        end
      end
  
      def embed_url
        raise NotImplementedError, "Can only call #embed_url on a subclass of acts_as_video class" unless type
        type.constantize.send :embed_url, embed_id
      end
      
      def embed_code(width = 720, height = 480)
        response({:maxwidth => width, :maxheight => height})['html']
      end  
      
      def response(options={})
        arguments = options.map{ |key, value| "&#{key}=#{value}"}.join
        uri = URI.parse(self.embed_url + arguments)
        res = Net::HTTP.get_response(uri)
        raise "Video doesnt exist" unless res.code == '200'
        JSON.parse(res.body)
      end
    end
  end
end