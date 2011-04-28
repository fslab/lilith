require 'spec_helper'

describe Article do
  it { should have_db_column(:id) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:abstract).of_type(:text) }
  it { should have_db_column(:body).of_type(:text) }

  it_should_behave_like "a timestamped model"

  context "default order" do
    it "should order by published_at in a descending way" do
      latest_article = described_class.make!(:published_at => Time.new(2011, 4, 28, 14), :updated_at => nil)
      older_article  = described_class.make!(:published_at => Time.new(2011, 4, 28, 10), :updated_at => nil)

      articles = described_class.all
      articles[0].should == latest_article
      articles[1].should == older_article
    end

    it "should order by updated_at in a descending way" do
      latest_article = described_class.make!(:updated_at => Time.new(2011, 4, 28, 14), :published_at => nil)
      older_article  = described_class.make!(:updated_at => Time.new(2011, 4, 28, 10), :published_at => nil)

      articles = described_class.all
      articles[0].should == latest_article
      articles[1].should == older_article
    end

    it "should prefer published_at before updated_at" do
      latest_article = described_class.make!(:published_at => Time.new(2011, 4, 28, 14), :updated_at => Time.new(2011, 4, 28, 10))
      older_article  = described_class.make!(:published_at => Time.new(2011, 4, 28, 10), :updated_at => Time.new(2011, 4, 28, 14))

      articles = described_class.all
      articles[0].should == latest_article
      articles[1].should == older_article
    end
  end

  context "sticky filters" do
    it "should allow to receive only sticky articles" do
      3.times do
        described_class.make!(:sticky => true)
        described_class.make!(:sticky => false)
      end

      described_class.sticky.all?{|article| article.sticky? }
    end

    it "should allow to receive only non-sticky articles" do
      3.times do
        described_class.make!(:sticky => true)
        described_class.make!(:sticky => false)
      end

      described_class.non_sticky.all?{|article| not article.sticky? }
    end
  end

  context "published filters" do
    it "should allow to receive only published articles" do
      3.times do
        described_class.make!(:published_at => Time.now)
        described_class.make!(:published_at => nil)
      end

      described_class.published.all?{|article| article.published? }
    end

    it "should allow to receive only unpublished articles" do
      3.times do
        described_class.make!(:published_at => Time.now)
        described_class.make!(:published_at => nil)
      end

      described_class.unpublished.all?{|article| not article.published? }
    end
  end

  context "#published? (virtual attribute)" do
    it "should return true if published_at is set" do
      article = described_class.make(:published_at => Time.now)

      article.should be_published
    end

    it "should return false if overridden even if published_at is set" do
      article = described_class.make(:published_at => Time.now)
      article.published = false
      article.should_not be_published
    end

    it "should return false if published_at is not set" do
      article = described_class.make(:published_at => nil)

      article.should_not be_published
    end

    it "should return true if overridden even if published_at is not set" do
      article = described_class.make(:published_at => nil)
      article.published = true
      article.should be_published
    end
  end

  context "#published= (virtual attribute)" do
    it "if set to true, save should set published_at if it is unset" do
      article = described_class.make(:published_at => nil)

      lambda {
        article.published = true
        article.save!
      }.should change{ article.published_at }.from(nil)
    end

    it "if set to true, save should not change published_at if it is already set" do
      article = described_class.make(:published_at => Time.now)

      lambda {
        article.published = true
        article.save!
      }.should_not change{ article.published_at }
    end

    it "if set to false, save should set published_at to nil if it is already set" do
      article = described_class.make(:published_at => Time.now)

      lambda {
        article.published = false
        article.save!
      }.should change{ article.published_at }.to(nil)
    end

    it "if set to false, save should not change published_at if it is unset" do
      article = described_class.make(:published_at => nil)

      lambda {
        article.published = false
        article.save!
      }.should_not change{ article.published_at }
    end
  end
end
