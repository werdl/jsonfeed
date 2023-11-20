module jsonfeed

import time

struct Post {
	title string @[required]
	author string
	date string = time.utc().format_rfc3339() @[required]
	desc string
	link string @[required]
}

struct Feed {
	pub:
	blogname string @[required]
	htmlurl string
	mut: posts []Post @[required]
}

pub fn Post.new(title string, author string, desc string, url string) Post {
	return Post{
		title: title
		author: author
		desc: desc
		link: url
	}
}
pub fn (mut f Feed) push(p Post) {
	f.posts << p
}
pub fn Feed.new(blogname string, htmlurl string) Feed {
	return Feed{
		posts: []
		blogname: blogname
		htmlurl: htmlurl
	}
}

pub fn (f Feed) rss() string {
	mut out:="
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<rss version=\"2.0\">

<channel>
  <title>${f.blogname}</title>
  <link>${f.htmlurl}</link>
  <description>${f.desc}</description>
	"
	for post in f.posts {
		out+="
  <item>
    <title>${post.title}</title>
    <link>${post.link}</link>
    <description>${post.desc}</description>
  </item>
  "
	}
	out+="
</channel>
</rss>
""
}