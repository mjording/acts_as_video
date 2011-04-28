require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Youtube do
  describe '#new' do
    context 'when valid' do      
      ['http://www.youtube.com/watch?v=qs0rqOo2Rdw'].each do |url|
        let(:video) { Video.new({:url => url}) }
        it "#{url} should be an instance of youtube" do
          video.type.should == "Youtube"
          video.title.should == 'Opening Day Shred Madness - Whistler/Blackcomb Opening Day 2010/2011'
        end
              
        it "#{url} should set the embed_id" do
          video.embed_id.should == 'qs0rqOo2Rdw'
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
end