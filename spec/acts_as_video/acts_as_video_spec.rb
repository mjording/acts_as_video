require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Video do
  it { should validate_presence_of :url }
  
  context "when using default options" do
    let(:video) { Video.new }
    subject { video }
    it { should respond_to :url }
    
    it "should have default video host options" do
      video.video_hosts.should == [:vimeo, :youtube]
    end
    
    it "should raise error when embed url is called" do
      lambda {video.embed_url}.should raise_error(NotImplementedError)
    end    
  end
  
  context "when using custom options" do
    let(:video) { VimeoVideo.new }
    it "should have only vimeo hosts options" do
      video.video_hosts.should == [:vimeo]
    end
  end
  
  describe '#new' do
    context 'when youtube' do      
      ['http://www.youtube.com/watch?v=qs0rqOo2Rdw'].each do |url|
        let(:video) { Video.new({:url => url}) }
        it "#{url} should be an instance of youtube" do
          video.host.should == "Youtube"
        end
                
        it "#{url} should set the embed_id" do
          video.embed_id.should == 'qs0rqOo2Rdw'
        end        
      end
      
      context 'when the video doesn\'t exist' do
        subject { Video.new(:url => 'http://www.youtube.com/watch?v=1234567890') }
        it { should have(1).errors_on(:url) }
      end      
    end
  end
  
  describe '#domain_from_url' do
    context "when valid url" do
      domains = [
                  {:url => 'http://www.youtube.com/watch?v=qs0rqOo2Rdw', :domain => 'youtube'}, 
                  {:url => 'vimeo.com/15556095', :domain => 'vimeo'}, 
                  {:url => 'www.27bslash6.com/foggot.html', :domain => '27bslash6'}
                ]
      domains.each do |url|
        it "should get domain from #{url[:url]}" do
          domain = Video.domain_from_url url[:url]
          domain.should == url[:domain]
        end
      end
    end
    
    context "when invalid url" do
      domains = [
                  {:url => 'http://www.youtube/watch?v=qs0rqOo2Rdw', :domain => 'youtube'}, 
                  {:url => 'vimeo/15556095', :domain => 'vimeo'}, 
                  {:url => 'www.27bslash6.abcdef/foggot.html', :domain => '27bslash6'}
                ]
      domains.each do |url|
        
        it "should raise invalid url error from #{url[:url]}" do
          lambda { Video.domain_from_url url[:url] }.should raise_error("Invalid Url")
        end
      end
    end  
  end
  
  describe "#class_from_url" do
    context "when supported url" do
      subject {Video.class_from_url 'vimeo.com/15556095'}
      it { should == Vimeo }
    end
    
    context "when unsupported url" do
      it "should raise error for unsupported domain" do
        lambda {Video.class_from_url 'www.27bslash6.com/foggot.html'}.should raise_error("Unsupported Domain")
      end
      
      it "should raise error for domain that is excluded from hosts" do
        lambda {VimeoVideo.class_from_url 'http://www.youtube.com/watch?v=qs0rqOo2Rdw'}.should raise_error("Unsupported Domain")
      end
    end
  end
end
