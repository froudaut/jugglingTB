function generateGraph(ballCount,maxThrow){
   sd = new StateDiagram(ballCount,maxThrow);
   sd.genDiagram();
}

/*do after DOM loads
button linking*/
window.onload = function(){

/*link buttons to operations*/
var graphInputButton = document.getElementById("graphInputButton");
var graphInput = document.getElementById("graphInput");
var highlightSiteswapButton = document.getElementById("highlightSiteswapButton");
var highlightSiteswapInput = document.getElementById("highlightSiteswapInput");
var transitionFromSiteswapInput = document.getElementById("transitionFromSiteswapInput");
var transitionToSiteswapInput = document.getElementById("transitionToSiteswapInput");
var transitionButton = document.getElementById("transitionButton");
var transitionCleanButton = document.getElementById("transitionCleanButton");

/*query params*/
var op = getParameterByName("op");
var nballs = getParameterByName("nballs");
var maxth = getParameterByName("maxth");
if (op="gengraph" && nballs && maxth){
   graphInput.value=nballs+","+maxth;
}

/*colors*/
REGEDGECOLOR="#e8e8e8";
SITESWAPEDGECOLOR="#f403fc";
SITESWAPNODECOLOR="#f403fc";
GROUNDSTATENODECOLOR="#000";
SITESWAP2EDGECOLOR="#35f2f2";
SITESWAP2NODECOLOR="#35f2f2";
TRANSITIONCOLOR="#4dab00";

var width = 960,height = 500;

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height)
    .attr("id","svg");

    // define arrow markers for graph links
svg.append('svg:defs').append('svg:marker')
    .attr('id', 'end-arrow')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 27)
    .attr('markerWidth', 4)
    .attr('markerHeight', 5)
    .attr('orient', 'auto')
    .append('svg:path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', REGEDGECOLOR)
;

svg.append('svg:defs').append('svg:marker')
    .attr('id', 'end-arrow-siteswap')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 22)
    .attr('markerWidth', 6)
    .attr('markerHeight', 7)
    .attr('orient', 'auto')
    .append('svg:path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', SITESWAPEDGECOLOR)
;

svg.append('svg:defs').append('svg:marker')
    .attr('id', 'end-arrow-siteswap2')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 22)
    .attr('markerWidth', 6)
    .attr('markerHeight', 7)
    .attr('orient', 'auto')
    .append('svg:path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', SITESWAP2EDGECOLOR)
;

svg.append('svg:defs').append('svg:marker')
    .attr('id', 'end-arrow-transition')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 22)
    .attr('markerWidth', 6)
    .attr('markerHeight', 7)
    .attr('orient', 'auto')
    .append('svg:path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', TRANSITIONCOLOR)
;

svg.append('svg:defs').append('svg:marker')
    .attr('id', 'start-arrow')
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', -3)
    .attr('markerWidth', 8)
    .attr('markerHeight', 8)
    .attr('orient', 'auto')
    .append('svg:path')
    .attr('d', 'M10,-5L0,0L10,5')
    .attr('fill', '#000')
;


const nodes=[
  // {name:"node1","group":1},
  // {name:"node2","group":2},
  // {name:"node3","group":2},
  // {name:"node4","group":3}
]

const links=[
  // {source:nodes[0],"target":nodes[1],"weight":3,left: false, right: true},
  // {source:nodes[1],"target":nodes[2],"weight":3,left: true, right: true}
]

function updateDiagram(nodes,links){
  d3.selectAll(".node").remove();
  d3.selectAll(".circle").remove();
  d3.selectAll(".edgepath").remove();
  d3.selectAll(".edgelabel").remove();
  d3.selectAll(".textPath").remove();
  d3.selectAll(".link").remove();
  d3.selectAll(".text").remove();


  var svg = d3.select("#svg");

  var force = d3.layout.force()
    .gravity(0.05)
    .distance(100)
    .charge(-500)
    .size([width, height]);

  force
      .nodes(nodes)
      .links(links)
      .start();

  var link = svg.selectAll(".link")
    .data(links)
    .enter().append("line")
    .attr("class", "link")
    .style("stroke-width", function(d) { return 1.5/*Math.sqrt(d.weight);*/ })
    .style('marker-start', (d) => d.left ? 'url(#start-arrow)' : '')
    .style('marker-end', function(d){
      if (d.right && d.siteswap1){
        return 'url(#end-arrow-siteswap)';
      }else if (d.right && d.siteswap2){
        return 'url(#end-arrow-siteswap2)';
      }else if (d.right && d.transition){
        return 'url(#end-arrow-transition)';
      }else if(d.right){
        return 'url(#end-arrow)';
      }else{
        return '';
      }})
    .style("stroke", function(d){ 
        if(d.siteswap1) {return SITESWAPEDGECOLOR}
        else if(d.siteswap2) {return SITESWAP2EDGECOLOR}
        else if(d.transition) {return TRANSITIONCOLOR}
        else {return REGEDGECOLOR}
    });

   var node = svg.selectAll(".node")
      .data(nodes)
      .enter().append("g")
      .attr("class", "node")
      .call(force.drag)
      .on('mouseover', function(d){
        var nodeSelection = d3.select(this);
        nodeSelection.select("text").style({opacity:'0.8'});
      })
      .on('mouseout', function(d){
        var nodeSelection = d3.select(this);
        nodeSelection.select("text").style({opacity:'0.0'});
      });

   var edgepaths = svg.selectAll(".edgepath")
      .data(links)
      .enter()
      .append('path')
      .attr({'d': function(d) {return 'M '+d.source.x+' '+d.source.y+' L '+ d.target.x +' '+d.target.y},
            'class':'edgepath',
            'fill-opacity':0,
            'stroke-opacity':0,
            'fill':'blue',
            'stroke':'red',
            'id':function(d,i) {return 'edgepath'+i}})
      .style("pointer-events", "none");

   var edgelabels = svg.selectAll(".edgelabel")
      .data(links)
      .enter()
      .append('text')
      .style("pointer-events", "none")
      .attr({'class':'edgelabel',
            'id':function(d,i){return 'edgelabel'+i},
            'dx':20,
            'dy':0,
            'font-size':10,
            'stroke':function(d){
              if(d.siteswap1){
                return SITESWAPEDGECOLOR;
              }else if(d.siteswap2){
                return SITESWAP2EDGECOLOR;
              }else if(d.transition){
                return TRANSITIONCOLOR;
              }else{
                return REGEDGECOLOR;
              }}});

   edgelabels.append('textPath')
      .attr('xlink:href',function(d,i) {return '#edgepath'+i})
      .style("pointer-events", "none")
      .text(function(d,i){return d.weight});

   node.append("circle")
      .attr("r","10")
      .style('fill',function(d) {
         if(d.groundState == true){return GROUNDSTATENODECOLOR}
         else if(d.siteswap1 == true){return SITESWAPNODECOLOR}
         else if(d.siteswap2 == true){return SITESWAP2NODECOLOR}
         else if(d.transition == true){return TRANSITIONCOLOR}
         else{return REGEDGECOLOR}
      });

    node.append("text")
        .attr("dx", 12)
        .attr("dy", ".35em")
        .attr("opacity","0.0")
        .text(function(d) { return d.name });

   force.on("tick", function() {
       link.attr("x1", function(d) { return d.source.x; })
           .attr("y1", function(d) { return d.source.y; })
           .attr("x2", function(d) { return d.target.x; })
           .attr("y2", function(d) { return d.target.y; });
      node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
   
      edgepaths.attr('d', function(d) { var path='M '+d.source.x+' '+d.source.y+' L '+ d.target.x +' '+d.target.y;
                                           //console.log(d)
                                           return path});       

      edgelabels.attr('transform',function(d,i){
         if (d.target.x<d.source.x){
            bbox = this.getBBox();
            rx = bbox.x+bbox.width/2;
            ry = bbox.y+bbox.height/2;
            return 'rotate(180 '+rx+' '+ry+')';
         }
         else {
            return 'rotate(0)';
         }
      });
   });
}

graphInputButton.addEventListener('click', function(){
   inputVals=graphInput.value.split(",");
   ballCount = inputVals[0];
   maxThrow = inputVals[1];
   console.log(graphInput.value);
   generateGraph(ballCount,maxThrow)

   sdw = new StateDiagramD3Wrapper(ballCount,maxThrow);
   sdw.findNodesAndEdges();
   updateDiagram(sdw.getNodes(),sdw.getEdges());
});

function siteswapValidateCSS(siteswapObj,inputElement){
  if (!siteswapObj.isValid()){
      /*display error on page*/
      if(!inputElement.classList.contains("is-invalid")){
        inputElement.classList.add("is-invalid");
      }
      if(inputElement.classList.contains("is-valid")){
        inputElement.classList.remove("is-valid");
      }
      return false;
   }else{
      if(inputElement.classList.contains("is-invalid")){
        inputElement.classList.remove("is-invalid");
      }
      if(!inputElement.classList.contains("is-valid")){
        inputElement.classList.add("is-valid");
      }
      return true;
   }
}

highlightSiteswapButton.addEventListener('click',function(){
   var siteswap = highlightSiteswapInput.value;
   var ss = new Siteswap(siteswap);

   if(!siteswapValidateCSS(ss,highlightSiteswapInput)){return}
   
   console.log(ss.ballCount()+","+ss.maxThrow());

   sdw = new StateDiagramD3Wrapper(ss.ballCount(),ss.maxThrow());
   sdw.findNodesAndEdges();
   ssArray = ss.getSiteswapArray();
   sdw.highlightSiteswap(ssArray);

   updateDiagram(sdw.getNodes(),sdw.getEdges());
});

function transitionSetup(){
  var siteswapFrom = transitionFromSiteswapInput.value;
  var siteswapTo = transitionToSiteswapInput.value;
  var ssFrom = new Siteswap(siteswapFrom);
  var ssTo = new Siteswap(siteswapTo);

  if(!siteswapValidateCSS(ssFrom,transitionFromSiteswapInput)){return}
  if(!siteswapValidateCSS(ssTo,transitionToSiteswapInput)){return}

  if (ssFrom.ballCount() != ssTo.ballCount()){
    /*display error*/
    return;
  }

  var maxThrow = ssFrom.maxThrow();
  if(ssFrom.maxThrow() < ssTo.maxThrow()){
    maxThrow = ssTo.maxThrow();
  }

  sdw = new StateDiagramD3Wrapper(ssFrom.ballCount(),maxThrow);
  var throwSequence1 = ssFrom.getSiteswapArray();
  var throwSequence2 = ssTo.getSiteswapArray();
  sdw.findNodesAndEdges();
  sdw.transitionSiteswap(throwSequence1,throwSequence2);
  return sdw;
}

transitionButton.addEventListener('click',function(){
  var sdw = transitionSetup();
  updateDiagram(sdw.getNodes(),sdw.getEdges());
});

transitionCleanButton.addEventListener('click',function(){
  var sdw = transitionSetup();
  sdw.cleanLayout();
  updateDiagram(sdw.getNodes(),sdw.getEdges());
});

};