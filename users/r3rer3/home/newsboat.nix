{...}: {
  programs.newsboat = {
    enable = true;

    extraConfig = ''
      delete-read-articles-on-quit yes
    '';

    urls = [
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
        title = "cristobal.space";
        url = "https://cristobal.space/rss.xml";
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
        title = "Matt Brown's Notes";
        url = "https://notes.mtb.xyz/feed";
      }
      {
        title = "Neo News";
        url = "https://neo.substack.com/feed";
      }
      {
        title = "Pope Head Post";
        url = "https://popehead.substack.com/feed";
      }
      {
        title = "Read Rust - All";
        url = "https://readrust.net/all/feed.rss";
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
        title = "The Prism";
        url = "https://gurwinder.substack.com/feed";
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
        title = "Unchained";
        url = "https://unchainedcrypto.substack.com/feed";
      }
    ];
  };
}
