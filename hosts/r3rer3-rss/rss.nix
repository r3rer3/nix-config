# Shared by the Miniflux droplet (hosts/r3rer3-rss) and the newsboat client
# (users/r3rer3/home/newsboat.nix), which syncs read state through it.
{
  # public hostname of the droplet; needs a DNS A record pointing at it
  domain = "rss.r3rer3.com";

  # subscriptions, reconciled into Miniflux on every deploy: feeds missing here
  # are unsubscribed, so add new ones here rather than in the web UI
  feeds = [
    {
      title = "3Blue1Brown mailing list";
      url = "https://3blue1brown.substack.com/feed";
    }
    {
      title = "Alin Tomescu";
      url = "https://alinush.github.io/feed";
    }
    {
      title = "Antonio’s Substack";
      url = "https://anmonteiro.substack.com/feed";
    }
    {
      title = "ByteByteGo Newsletter";
      url = "https://blog.bytebytego.com/feed";
    }
    {
      title = "Cryptology ePrint Archive";
      url = "https://eprint.iacr.org/rss/rss.xml";
    }
    {
      title = "Decentralized Thoughts";
      url = "https://decentralizedthoughts.github.io/feed";
    }
    {
      title = "Drew DeVault's blog";
      url = "https://drewdevault.com/blog/index.xml";
    }
    {
      title = "Faultlore";
      url = "https://faultlore.com/blah/rss.xml";
    }
    {
      title = "Fintech Business Weekly";
      url = "https://fintechbusinessweekly.substack.com/feed";
    }
    {
      title = "Neo News";
      url = "https://neo.substack.com/feed";
    }
    {
      title = "the singularity is nearer";
      url = "https://geohot.github.io/blog/feed.xml";
    }
    {
      title = "The Monero Moon";
      url = "https://www.themoneromoon.com/feed";
    }
    {
      title = "The Stanford Review";
      url = "https://stanfordreview.org/rss/";
    }
    {
      title = "ThursdAI - Recaps of the most high signal AI weekly spaces";
      url = "https://sub.thursdai.news/feed";
    }
    {
      title = "Epoch AI";
      url = "https://epochai.substack.com/feed";
    }
    {
      title = "Interconnects AI";
      url = "https://www.interconnects.ai/feed";
    }
    {
      title = "Mindful Modeler";
      url = "https://mindfulmodeler.substack.com/feed";
    }
    {
      title = "Jam with AI";
      url = "https://jamwithai.substack.com/feed";
    }
    {
      title = "Ahead of AI";
      url = "https://magazine.sebastianraschka.com/feed";
    }
  ];
}
