require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vimeo do
  describe '#new' do
    context 'when vimeo' do      
      ['http://www.vimeo.com/17147129'].each do |url|
        let(:video) { Video.new(:url => url) }
        it "#{url} should be an instance of vimeo" do
          video.type.should == "Vimeo"
          video.title.should == 'Tourism Whistler Commercial'
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