require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vimeo do
  describe '#new' do
    context 'when vimeo' do      
      ['http://www.vimeo.com/17147129'].each do |url|
        let(:video) { Video.new(:url => url) }
        it "#{url} should be an instance of vimeo" do
          video.type.should == "Vimeo"
          video.title.should == 'Tourism Whistler Commercial'
          video.thumbnail_url.should == 'http://i2.ytimg.com/vi/qs0rqOo2Rdw/hqdefault.jpg'
          video.embed_code.should == '<iframe src="http://player.vimeo.com/video/17147129" width="720" height="405" frameborder="0"></iframe>' 
          video.embed_code(200, 200).should == '<iframe src="http://player.vimeo.com/video/17147129" width="200" height="113" frameborder="0"></iframe>'   
        end
            
        it "#{url} should set the embed_id" do
          video.embed_id.should == '17147129'
        end
      end
  
      context 'when the video doesn\'t exist' do
        let(:video)  { Video.new :url => 'http://www.vimeo.com/1234567890' }
        subject { video }
        it { should_not be_valid }
        it "should have 1 error on url" do
          video.errors[:url].size.should == 1
        end
      end
    end
  end  
end