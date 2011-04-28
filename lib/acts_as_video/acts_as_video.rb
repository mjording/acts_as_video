require 'net/http'
module ActsAsVideo
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def acts_as_video(options = {})
      cattr_accessor :video_hosts      
      attr :url
      validates_presence_of :url, :on => :create
      
      self.video_hosts = (options[:video_hosts] || [:vimeo, :youtube])
      
      send :include, InstanceMethods

      private
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
  end
  
  module InstanceMethods
    def url=(url)
      begin
        domain_class = self.class.send :class_from_url, url          
        self.host = domain_class.to_s
        self.embed_id = embed_id_from_url(url, domain_class)
        data = response
        self.title = data['title']
        self.thumbnail_url = data['thumbnail_url']
        @url = url
      rescue Exception => ex
        case ex.message          
          when "Unsupported Domain"
            self.errors.add :url, "Unsupported Domain, supported video hosts are #{self.class.video_hosts.join(', ')}"
          when "Invalid Url"
            self.errors.add :url, "Invalid Url"
          when "Video doesnt exist"
            self.errors.add :url, "Video not found"
          else
            raise ex
        end
      end
    end
    
    def url
      @url
    end

    def embed_id_from_url(url, host)
      match = url.match(host::EMBED_ID_REGEX)
      match[1] ? match[1] : raise("Video doesnt exist")
    end
    
    def embed_code(width = 720, height = 480)
      response({:maxwidth => width, :maxheight => height})['html']
    end  

    def embed_url
      raise NotImplementedError, "Can only call #embed_url on a subclass of acts_as_video class" unless host
      host.constantize.send :embed_url, embed_id
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
