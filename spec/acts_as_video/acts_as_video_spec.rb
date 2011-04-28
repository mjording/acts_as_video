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
  
  describe "#url=" do
    context "when supported url" do
      vid_id = 123
      FakeWeb.register_uri(:get, Vimeo.embed_url(vid_id), :status => ["200", "OK"], :body => {:title => "Hi"}.to_json)
      subject { Video.new :url => "vimeo.com/#{vid_id}" }
      it { should be_valid }
      its(:type) { should == 'Vimeo' }
      its(:title) { should == 'Hi' }
    end
    
    context "when unsupported url" do
      let(:video) {Video.new :url => 'www.27bslash6.com/foggot.html'}
      subject { video }
      it { should_not be_valid }
      it "should have 1 error on url" do
        video.errors[:url].size.should == 1
        video.errors[:url].should include("Translation Here")
      end
    end
    
    context "when supported but excuded domain" do
      let(:video) {VimeoVideo.new :url => 'http://www.youtube.com/watch?v=qs0rqOo2Rdw'}
      subject { video }
      it { should_not be_valid }
      it "should have 1 error on url" do
        video.errors[:url].size.should == 1
        video.errors[:url].should include("Translation Here")
      end
    end
    
    context "when supported url but invalid url" do
      vid_id = 'qs0rqOo2Rdw'
      FakeWeb.register_uri(:get, Youtube.embed_url(vid_id), :status => ["404", "Not Found"])
      let(:video) {Video.new :url => "http://www.youtube.com/watch?v=#{vid_id}"}
      subject { video }
      it { should_not be_valid }
      it "should have 1 error on url" do
        video.errors[:url].size.should == 1
        video.errors[:url].should include("Translation Here")
      end
    end
  end
  
  describe '#embed_code' do
    FakeWeb.register_uri(:get, /http:\/\/www.youtube.com(?:.*)/, :status => ["200", "OK"], :body => {:html => 'embed'}.to_json)
    let(:video) {Video.new :url => "http://www.youtube.com/watch?v=1234"}
    it "should request embed code with default height and width" do
      video.embed_code.should == 'embed'
      FakeWeb.should have_requested(:get, /.*&maxwidth=720&maxheight=480/)
    end
    
    it "should request embed code with custom height and width" do
      video.embed_code(200, 200).should == 'embed'
      FakeWeb.should have_requested(:get, /.*&maxwidth=200&maxheight=200/)
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
          domain = Video.send :domain_from_url, url[:url]
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
          lambda { Video.send :domain_from_url, url[:url] }.should raise_error("Invalid Url")
        end
      end
    end  
  end
  
  describe "#class_from_url" do
    context "when supported url" do
      subject {Video.send :class_from_url, 'vimeo.com/15556095'}
      it { should == Vimeo }
    end
    
    context "when unsupported url" do
      it "should raise error for unsupported domain" do
        lambda {Video.send :class_from_url, 'www.27bslash6.com/foggot.html'}.should raise_error("Unsupported Domain")
      end
      
      it "should raise error for domain that is excluded from hosts" do
        lambda {VimeoVideo.send :class_from_url, 'http://www.youtube.com/watch?v=qs0rqOo2Rdw'}.should raise_error("Unsupported Domain")
      end
    end
  end
end
  
