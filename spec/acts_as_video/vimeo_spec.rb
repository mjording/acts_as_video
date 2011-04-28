require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vimeo do
  before(:all) do
    FakeWeb.clean_registry    
  end
  describe '#new' do
    context 'when vimeo' do      
      let(:video) { Video.new(:url => 'http://www.vimeo.com/17147129') }
      subject { video }
      it { should be_valid }
      its(:type) { should == "Vimeo"}
      its(:title) { should == 'Tourism Whistler Commercial' }
      its(:thumbnail_url) { should == 'http://b.vimeocdn.com/ts/106/104/106104409_640.jpg' }
      its(:embed_code) { should == '<iframe src="http://player.vimeo.com/video/17147129" width="720" height="405" frameborder="0"></iframe>'}
      its(:embed_id) { should == '17147129'}
      it "should have a smaller embed code if passed arguments" do
        video.embed_code(200, 200).should == '<iframe src="http://player.vimeo.com/video/17147129" width="200" height="113" frameborder="0"></iframe>'
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