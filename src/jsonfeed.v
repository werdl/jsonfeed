module jsonfeed

import time
import json
import encoding.xml

struct Post {
	title string @[required]
	author string
	date string = time.utc().format_rfc3339() @[required]
	desc string
	link string @[required]
}

struct Feed {
	pub:
		jsonfeed_v string = "0.1.0" @[required]
 		blogname string @[required]
		htmlurl string @[required]
		desc string @[required]
	mut: 
		posts []Post @[required]
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
pub fn Feed.new(blogname string, htmlurl string, desc string) Feed {
	return Feed{
		posts: []
		blogname: blogname
		htmlurl: htmlurl
		desc: desc
	}
}

pub fn Feed.rss(s string) Feed {


	doc := xml.XMLDocument.from_string(s) or { panic(err) }
	
	chann:=doc.get_elements_by_tag("channel")[0]

	title:=chann.get_elements_by_tag("title")[0]

	link:=chann.get_elements_by_tag("link")[0]

	desc:=chann.get_elements_by_tag("description")[0]

	posts:=chann.get_elements_by_tag("item")


	mut postss:=[]Post{}
	for node in posts {
		postss << Post.new(node.get_elements_by_tag("title")[0], "unknown", node.get_elements_by_tag("description")[0], node.get_elements_by_tag("link")[0])
	}



	mut x:=Feed.new("Test Blog", "https://example.com", "My Testing Blog")
	x.posts=postss
	return x
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
"
	return out
}

pub fn (f Feed) json() string {
	return json.encode_pretty (f)
}

pub fn feed(s string) Feed {
	return json.decode(Feed, s) or { panic(err) }
}