
module Viz
	class Error < StandardError; 
	end
  
  
	class GG

	  @@ggid = 1
	  attr_accessor :domain 
	  attr_accessor :outerRadius 
	  attr_accessor :innerRadius 
	  attr_accessor :ticks 
	  attr_accessor :majorTicks 
	  attr_accessor :value 
	  attr_accessor :faceColor 
	  attr_accessor :innerFaceColor 
	  attr_accessor :needleColor 
	  attr_accessor :minorTickStart 
	  attr_accessor :majorTickStart
	  attr_accessor :angleOffset
	  attr_accessor :labelLocation
	  attr_accessor :guagelabel
	  attr_accessor :id
	  attr_accessor :number
	  
	  def initialize(args)
		  #super(args)
		  @domain= args.fetch(:domain, [0,100])
		  @outerRadius= args.fetch(:outerRadius, "100")
		  @innerRadius= args.fetch(:innerRadius, "20")
		  @ticks= args.fetch(:ticks, [domain[0], domain[1]+1, "5"])
		  @majorTicks = args.fetch(:majorTicks, "function(d){return (d)%10===0;}")
		  @value= args.fetch(:value, domain[0]+(domain[1] - domain[0])/2)
		  #.duration(1000)
		  @faceColor= args.fetch(:faceColor, "#003CCC")
		  @innerFaceColor= args.fetch(:innerFaceColor, "#003CFF")
		  @needleColor= args.fetch(:needleColor, "#fff")
		  @minorTickStart= args.fetch(:minorTickStart, "0.9")
		  @majorTickStart= args.fetch(:majorTickStart, "0.85")
		  @angleOffset= args.fetch(:angleOffset, "Math.PI/2")
		  @labelLocation= args.fetch(:labelLocation, "0.68")
		  @guagelabel= args.fetch(:guagelabel, "")
		  @id = "svg#{@@ggid}"
		  @number = @@ggid
		  @@ggid +=1

	  end
		
		
	  def self.ggid
		@@ggid
	  end
	  def ggid
		@@ggid
	  end
	  
	  
	  
	  def render(width = 200, height = 200)
htmlout = <<END
<div id="div#{self.id}">

<svg id="#{self.id}" width="#{width}" height="#{height}"></svg><br/>
<p style="text-align: center;">#{self.guagelabel}</p>

<script src="https://d3js.org/d3.v3.min.js"></script>
<script src="http://vizjs.org/viz.v1.0.0.min.js"></script>
<script>
var #{self.id}=d3.select("##{self.id}");
var frame#{self.number}=#{self.id}.append("g").attr("transform","translate(#{width/2}, #{height/2})");
var range#{self.number} = [#{self.domain[0]}, #{self.domain[1]}];

var guage#{self.number} = viz.gg()
  .domain(range#{self.number})
  .outerRadius(#{self.outerRadius})
  .innerRadius(#{self.innerRadius})
  .ticks(d3.range(#{self.ticks.join(",")}))
  .majorTicks(#{self.majorTicks})
  .value(#{self.value})
  //.duration(1000)
  .faceColor("#{self.faceColor}")
  .innerFaceColor("#{self.innerFaceColor}")
  .needleColor("#{self.needleColor}")
  .minorTickStart(#{self.minorTickStart.to_s})
  .majorTickStart(#{self.majorTickStart.to_s})
  .angleOffset(#{self.angleOffset.to_s})
  .labelLocation(#{self.labelLocation.to_s})
;
guage#{self.number}.defs(#{self.id}, #{self.number});
frame#{self.number}.call(guage#{self.number});  
</script>
</div>
END

		return htmlout

	  end
	  
	  
	def self.defaultStylesheet
		defaultStylesheet
	end
	
	  def defaultStylesheet
		
		style = <<END
<style>
.label{
	font-size:12.5px;
	fill:#ffffff;
	text-anchor:middle;
	alignment-baseline:middle;
}
.face{
	stroke:#c8c8c8;
	stroke-width:2;
}
.minorTicks{
	stroke-width:2;
	stroke:white;
}
.majorTicks{
	stroke:white;
	stroke-width:3;
}

</style>

END
		return style
	  end
	  
	  
	  
	end  # end of class
end # end of module

	
