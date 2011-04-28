require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Youtube do
  before(:all) do
    FakeWeb.clean_registry    
  end
  describe '#new' do
    context 'when valid' do      
      let(:video) { Video.new :url => 'http://www.youtube.com/watch?v=qs0rqOo2Rdw' }
      subject { video }
      it { should be_valid }
      its(:host) { should == "Youtube"}
      its(:title) { should == 'Opening Day Shred Madness - Whistler/Blackcomb Opening Day 2010/2011' }
      its(:thumbnail_url) { should == 'http://i2.ytimg.com/vi/qs0rqOo2Rdw/hqdefault.jpg' }
      its(:embed_code) { should == "<object width=\"720\" height=\"430\"><param name=\"movie\" value=\"http://www.youtube.com/v/qs0rqOo2Rdw?version=3\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"http://www.youtube.com/v/qs0rqOo2Rdw?version=3\" type=\"application/x-shockwave-flash\" width=\"720\" height=\"430\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>"}
      its(:embed_id) { should == 'qs0rqOo2Rdw'}
      it "should have a smaller embed code if passed arguments" do
        video.embed_code(200, 200).should == "<object width=\"200\" height=\"138\"><param name=\"movie\" value=\"http://www.youtube.com/v/qs0rqOo2Rdw?version=3\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"http://www.youtube.com/v/qs0rqOo2Rdw?version=3\" type=\"application/x-shockwave-flash\" width=\"200\" height=\"138\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>"
      end
    end
    
    context 'when the video doesn\'t exist' do
      let(:video) { Video.new(:url => 'http://www.youtube.com/watch?v=1234567890') }
      subject { video }
      it { should_not be_valid }
      it "should have 1 error on url" do
        video.errors[:url].size.should == 1
      end
    end      
  end
end