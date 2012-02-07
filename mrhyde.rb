require 'trollop'
require 'time'
require 'fileutils'

@opts = Trollop::options do
  opt :title, "Title for the blog post.", :type => String
  opt :layout, "Layout", :default => "default"
  opt :date, "Post date in YYYY-MM-DD format. Current date is set as default", :default => Time.new.strftime("%Y-%m-%d")
  opt :draft, "Create a draft for the future post. (this will copy the post templated in _drafts folder.)"
end

Trollop::die :title, "must be provided." if !@opts[:title]

filename = Time.parse(@opts[:date]).strftime("%Y-%m-%d")
filename << "-" <<  @opts[:title].split(" ").collect! {|item| item.downcase }.join("-")
filename << (filename.end_with?(".") ? "md" : ".md")

post = File.open(filename, 'w') do |f|
   f.puts "---"
   f.puts "layout : " << @opts[:layout].to_s
   f.puts "title : " <<  @opts[:title]
   f.puts "---"
end

@opts[:draft] ? FileUtils.mv(filename, "_drafts/"+filename) : (FileUtils.mv filename, "_posts/"+filename)

