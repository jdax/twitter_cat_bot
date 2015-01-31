Hello!
This is a bot designed to tweet random pictures of cats. 
There is a bots.rb and config.yml that will walk you through setting it up yourself.
You will need to create a twitter account to run your cat bot from, a twitter developer account, an AWS account, and a heroku account. 
Create your twitter account, then attached to that account create a twitter developer account. Get the keys from both of those and put them in the config.yml in the appropriate places.
Create an AWS account and in S3 create a bucket for your cat pictures. Upload your cat pictures (this may take awhile if you have a lot of them).
Get your keys from AWS and put them in the config.yml document in the appropriate places.
Got through the bots.rb and put in your own info where it specifies, and change things to suit your needs.
Create a git repository and upload it to heroku. You can set it to deploy 1 time, and it will start tweeting cat pictures at the specified interval indefinitely! If someone tweets at the cat bot, it will reply with yet another cat picture! 

I suppose you could, if you want, use this to create a dog bot or a ferret bot. I guess. Maybe.