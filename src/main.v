module main

import jsonfeed

fn main() {
	mut myfeed:=jsonfeed.Feed.new("Test Blog", "https://example.com", "My Testing Blog")
	myfeed.push(jsonfeed.Post.new("Test Post", "werdl", "A Testing post", "example.com/test"))

	println(jsonfeed.Feed.rss(myfeed.rss()))
}
