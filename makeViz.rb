require "./gg.rb"
require "cgi"
require "rest-client"
require "json"


#c = cgi.new
f = File.read(ARGV[0])
fj = JSON.parse(f)


result = fj["evaluationResult"]
resj = JSON.parse(result)

fs, as, is, rs, fscores, ascores, iscores, rscores = 0,0,0,0,0,0,0,0

resj.keys.each do |uri|
  puts "processing #{uri}"
  
  html = RestClient.get(uri)
  #puts html
  matches = /Tests\sPrinciple.*?\"\>([^\<]+)\</m.match(html)
  letter = matches[1][0]
  principle = matches[1]
  thisscore = resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"].to_i
  case letter.downcase
  when "f"
	fs += 1
	fscores = fscores + thisscore
  when "a"
	as += 1
	ascores = ascores + thisscore
  when "i"
	is += 1
	iscores = iscores + thisscore
  when "r"
	rs += 1
	rscores = rscores + thisscore
  end
end

ggf = Viz::GG.new({domain: [0,fs], ticks: [0, fs+1, 1], majorTicks: "function(d){return true;}", value: fscores, guagelabel: "F Metrics"})
gga = Viz::GG.new({domain: [0,as], ticks: [0, as+1, 1],  majorTicks: "function(d){return true;}", value: ascores, guagelabel: "A Metrics"})
ggi = Viz::GG.new({domain: [0,is], ticks: [0, is+1, 1],  majorTicks: "function(d){return true;}", value: iscores, guagelabel: "I Metrics"})
ggr = Viz::GG.new({domain: [0,rs], ticks: [0, rs+1, 1],  majorTicks: "function(d){return true;}", value: rscores, guagelabel: "R Metrics"})

File.write("/var/www/html/output.html", "<html>" + ggf.defaultStylesheet + "<body>" + ggf.render + gga.render + ggi.render + ggr.render + "</body></html>")
