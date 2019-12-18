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
  html = RestClient.get(uri)
  #puts html
  matches = /Tests\sPrinciple.*?\"\>([^\<]+)\</m.match(html)
  letter = matches[1][0]
  principle = matches[1]
  thisscore = resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"]
  case letter.downcase
  when "f"
	fs += 1
	fscores = fscores + resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"].to_i
  when "a"
	as += 1
	ascores = ascores + resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"].to_i
  when "i"
	is += 1
	iscores = iscores + resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"].to_i
  when "r"
	rs += 1
	rscores = rscores + resj[uri].first["http://semanticscience.org/resource/SIO_000300"].first["@value"].to_i
  end
end

ggf = Viz::GG.new({domain: [0,fs], ticks: [0, fs+1, 1], majorTicks: "function(d){return true;}", value: fscores})
gga = Viz::GG.new({domain: [0,as], ticks: [0, fs+1, 1],  majorTicks: "function(d){return true;}", value: ascores})
ggi = Viz::GG.new({domain: [0,is], ticks: [0, fs+1, 1],  majorTicks: "function(d){return true;}", value: iscores})
ggr = Viz::GG.new({domain: [0,rs], ticks: [0, fs+1, 1],  majorTicks: "function(d){return true;}", value: rscores})

File.write("output.html", "<html>" + ggf.defaultStylesheet + "<body>" + ggf.render + gga.render + ggi.render + ggr.render + "</body></html>")
