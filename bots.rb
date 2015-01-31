require 'twitter_ebooks'
require 'aws-sdk'
require 'twitter'
require 'faraday'


def aws_params
  config = YAML.load_file("config.yml")
  {
    :access_key_id => config["aws"]["access_key_id"],
    :secret_access_key => config["aws"]["secret_access_key"]
  }
end

AWS.config(aws_params)

class CatPictureDownloader
  attr_reader :s3, :download_path

  def initialize(aws_keys)
    @s3 = AWS::S3.new(aws_keys)
    @download_path = "/tmp/random_cat_pic.jpg"
  end

  def cat_pic_bucket
    s3.buckets[''] # put your bucket name in the ''
  end

  def random_cat_pic
    cat_pic_bucket.objects.to_a.sample
  end

  def download_random_cat_pic
    File.open(download_path, 'wb') do |file|
      random_cat_pic.read do |chunk|
        file.write(chunk)
      end
    end
  end
end


# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    config = YAML.load_file("config.yml")
    self.consumer_key = config["app"]["consumer_key"]
    self.consumer_secret = config["app"]["consumer_secret"]

    # Users to block instead of interacting with
    # self.blacklist = ['']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6

    @cat_pic_downloader = CatPictureDownloader.new(aws_params)
  end

  def tweet_cat_pic(message = "") # put your message in the ""
    @cat_pic_downloader.download_random_cat_pic

    pictweet(message, @cat_pic_downloader.download_path)
  end


  def on_startup
    tweet_cat_pic  
    scheduler.every '1h' do # can change to any increment you'd like
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      tweet_cat_pic
    end
  end

  def on_message(dm)
    # Reply to a DM
    # reply(dm, "secret secrets")
  end

  def on_follow(user)
    # Follow a user back
    follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    # reply(tweet, "")
    tweet_cat_pic "@#{tweet.user.screen_name}, here is another cat!" # can change response
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    # reply(tweet, "nice tweet")
  end
end

# Make a MyBot and attach it to an account
MyBot.new("") do |bot| #put your bot name in the ""
  config = YAML.load_file("config.yml")
  bot.access_token =  config['twitter']['access_token']
  bot.access_token_secret = config['twitter']['access_token_secret']
end
