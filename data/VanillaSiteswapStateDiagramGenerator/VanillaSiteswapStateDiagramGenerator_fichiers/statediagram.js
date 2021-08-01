class State{
	/*
	opts={
		"numberOfBalls":3,
		"initState":[0,1,1,1]
	}
	*/
	constructor(opts){
		if (!opts["numberOfBalls"]){
			throw "must include numberOfBalls";
		}
		var numberOfBalls = opts["numberOfBalls"];
		if (opts["initState"]){
			this.state = opts["initState"];
		}else{
			this.state = new Array(numberOfBalls);
			for (var i = 0; i < numberOfBalls; i++) {
				this.state[i] = 1;
			}
		}
		this.numberOfBalls = numberOfBalls;
	}

	getStateString(){
		return this.state.join("");
	}

	getStateArray(){
		return this.state;
	}

	/*returns next state as object, false if cannot*/
	genNextState(throwHeight){
		var calcState = State.calcNextState(this.state,throwHeight);
		if(!calcState){
			return false;
		}else{
			return new State(
				{"numberOfBalls":this.numberOfBalls,
				"initState":calcState}
				);
		}
	}

	equals(state){
		return this.getStateString() == state.getStateString();
	}

	//logic for state transition
	static calcNextState(arr,throwHeight){
		if (arr.length == 0){
			return false;
		}
		if (throwHeight == 0 && arr[0] == 0){
			return arr.slice(1,arr.length);
		}else if(arr[0] == 0){
			return false;
		}else if(throwHeight<arr.length){
			if(arr[throwHeight] == 0){
				var narr = arr.slice(1,arr.length);
				narr[throwHeight-1] = 1;
				return narr;
			}else{
				return false;
			}
		}else if(throwHeight>=arr.length){
			var narr = new Array(throwHeight);
			for(var i = 1; i<arr.length;i++){
				narr[i-1]=arr[i];
			}
			for (i-=1; i < throwHeight-1; i++) {
				narr[i] = 0;
			}
			narr[throwHeight-1] = 1;
			return narr
		}
	}
}

class Node{
	constructor(stateObj){
		this.state = stateObj; //State Object
		this.edges = {}; //Array of Node Objects
	}
	addDirectedEdge(throwNum,nextNode){
		this.edges[throwNum] = nextNode;
	}
	genNextNode(throwNum){
		return new Node(this.state.genNextState(throwNum));
	}
	getStateString(){
		return this.state.getStateString();
	}
	getStateArray(){
		return this.state.getStateArray();
	}
	hasEdge(edge){
		return this.edges.hasOwnProperty(edge);
	}
	equals(node){
		return this.state.equals(node.state);
	}
}

class Queue{
	constructor() { 
		this.items = [];
	}
	enqueue(ele){
		this.items.push(ele);
	}
	dequeue(){
		if(this.isEmpty()){
			return False;
		}
		return this.items.shift();
	}
	isEmpty(){
		return this.items.length == 0;
	}
	printQueue() { 
		var str = ""; 
		for(var i = 0; i < this.items.length; i++) 
			str += this.items[i] +" "; 
		return str; 
	}
}


class StateDiagram{
	constructor(ballCount,maxThrow){
		this.startingNode = new Node(new State({"numberOfBalls":ballCount}));
		this.ballCount = ballCount;
		this.maxThrow = maxThrow;
	}
	getStartingNode(){
		return this.startingNode;
	}

	genDiagram(){
		//https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/
		//via bfs
		var curr = this.startingNode

		//needs to work for two arrays
		var directory = {};
		directory[curr.getStateString()]=curr;

		var q = new Queue();
		q.enqueue(curr);

		while(!q.isEmpty()){
			curr = q.dequeue();
			// console.log("curr q ele:"+curr.getStateString());

			for(var thrown=0;thrown<=this.maxThrow;thrown++){
				//calculate next state array
				// console.log("prethrown:"+thrown+"|"+curr.getStateArray());
				var nextStateArray = State.calcNextState(curr.getStateArray(),thrown);
				// console.log("thrown:"+thrown+","+nextStateArray);
				//valid next state?
				if (!nextStateArray){
					continue;
				}

				//does the state exist yet?
				if(!(nextStateArray.join("") in directory)){
					// console.log(nextStateArray.join(""));
					//no, create node
					var nextNode = new Node(
						new State(
							{numberOfBalls:this.ballCount,
							initState:nextStateArray}
							)
						);
					//add to queue
					q.enqueue(nextNode);
					//add to directory
					directory[nextNode.getStateString()] = nextNode;
				}
				//re-retreive from directory for edges to self
				curr.addDirectedEdge(thrown/*nextStateArray.join("")*/,
					directory[nextStateArray.join("")]);
				//optimization: if first state value is a zero, a zero will
				//   be the only value that can be thrown
				if (curr.getStateArray()[0] == 0){
					break;
				}
			}
			// console.log(curr.edges);
		}
	}

	findEdgeSequenceStartingNode(sequence){
		/*BFS to each node, then DFS to find sequence*/
		/*takes in array
		returns starting nodes of sequence edge*/
		/*assumes you already tested the validity, so will work
		on pregenerated graph.*/
		var curr = this.startingNode;
		var visited = {};
		visited[curr.getStateString()] = true;

		var q = new Queue();
		q.enqueue(curr);

		while(!q.isEmpty()){
			curr = q.dequeue();

			if(StateDiagram.findEdgeSequenceRec(curr,curr,sequence)){
				return curr;
			}

			for (var thrown of Object.keys(curr.edges)){
				var nextNode = curr.edges[thrown];
				if (!visited[nextNode.getStateString()]){
					q.enqueue(nextNode);
					visited[nextNode.getStateString()] = true;
				}
			}
		}
		throw "could not find sequence in graph";
	}

	static findEdgeSequenceRec(firstNode,curr,sequence){
		/*returns true if the sequence starts with this node*/
		if (sequence.length == 0 && curr === firstNode){
			return true;
		}
		if (curr.hasEdge(sequence[0])){
			var nextNode = curr.edges[sequence[0]];
			var nextSequence = sequence.slice(1,sequence.length);
			return StateDiagram.findEdgeSequenceRec(firstNode,nextNode,nextSequence);
		}else{
			return false;
		}
	}

	shortestPath(fromNode,toNodes){
		/*takes in a fromNode and toNodes[]*/
		/*returns array of nodes and array of edges interleaved*/
		var curr = fromNode;
		var visited = {};
		visited[curr.getStateString()] = true;
		var backtrackTable = {};
		/*represented by bcktrktbl[string] = {edge:throw to get you to->, node:where that throw gets you}*/
		backtrackTable[curr.getStateString()] = false;

		var toNodesLookup = {} /*for fast lookup*/
		for (var i=0; i< toNodes.length; i++){
			toNodesLookup[toNodes[i].getStateString()]=toNodes[i];
		}

		var q = new Queue();
		q.enqueue(curr);

		while(!q.isEmpty()){
			curr = q.dequeue();
			
			if (toNodesLookup.hasOwnProperty(curr.getStateString())){
				break;
			}

			for (var thrown of Object.keys(curr.edges)){
				var nextNode = curr.edges[thrown];
				if (!visited[nextNode.getStateString()]){
					q.enqueue(nextNode);
					visited[nextNode.getStateString()] = true;
					backtrackTable[nextNode.getStateString()] = {node:curr,edge:thrown};
				}
			}
		}

		var fullPath = [{node:curr,edge:false}];
		while (backtrackTable[curr.getStateString()]){
			fullPath.push(backtrackTable[curr.getStateString()]);
			curr = backtrackTable[curr.getStateString()].node;
		}
		return fullPath;
	}

	shortestPathFromNodes(fromNodes,toNodes){
		var shortestPath = [];
		for (var i=0;i<fromNodes.length;i++){
			var path = this.shortestPath(fromNodes[i],toNodes);	
			if (path.length < shortestPath || shortestPath.length == 0){
				shortestPath = path;
			}
		}
		// console.log("shortestpath:")
		// console.log(shortestPath);
		return shortestPath;
	}

	findEdgeSequenceArray(throwSequence){
		var curr = this.findEdgeSequenceStartingNode(throwSequence);
		var nodeSequence = [];
		for (var i=0; i<throwSequence.length;i++){
			nodeSequence.push(curr);
			curr = curr.edges[throwSequence[i]];
		}
		return nodeSequence;
	}

}

class StateDiagramD3Wrapper{
	constructor(ballCount,maxThrow){
		this.stateDiagram = new StateDiagram(ballCount,maxThrow);
		this.stateDiagram.genDiagram();
		this.nodes=[];
		this.edges=[];
		this.indexNodes={}; /*stores an index of the each node*/
		this.indexEdges={}; /*stores a fast lookup of edges*/
	}
	getNodes(){
		return this.nodes;
	}
	getEdges(){
		return this.edges;
	}
	findNodesAndEdges(){ /*bfs*/
		/*the sole purpose of this function is to format edges and nodes
		for D3*/
		this.nodes = [];
		this.edges = [];
		this.indexNodes={};
		this.indexEdges={};
		/*https://stackoverflow.com/questions/12007141/d3-js-force-directed-graph-reduce-edge-crossings-by-making-edges-repel-each-oth*/
		var i = 0;/*index of nodes*/
		var j = 0;/*index of edges*/

		var curr = this.stateDiagram.getStartingNode();

		//needs to work for two arrays
		var visited = {};
		visited[curr.getStateString()]=i;

		/*add node indeces for fast lookup*/
		this.indexNodes[curr.getStateString()]=i;
		i++;

		var q = new Queue();
		q.enqueue(curr);

		var groundState = true;

		while(!q.isEmpty()){
			curr = q.dequeue();
			this.nodes.push({
				"name":curr.getStateString(),
				"groundState":groundState,
				"transition":false});
			groundState = false;
			this.indexEdges[curr.getStateString()]={};
			for (var thrown of Object.keys(curr.edges)){
				var nextNode = curr.edges[thrown];

				if(!visited.hasOwnProperty(nextNode.getStateString())){
					q.enqueue(nextNode);
					visited[nextNode.getStateString()] = i;
					this.indexNodes[nextNode.getStateString()]=i;
					i++;
				}

				/*add edges*/ /*NEED TOassign Weight!*/
				this.edges.push({"source":visited[curr.getStateString()],
					"target":visited[nextNode.getStateString()],
					"weight":thrown,left: false, right: true,
					"siteswap1":false, "siteswap2":false,"transition":false});

				/*add edge indeces for fast lookup*/
				this.indexEdges[curr.getStateString()][Number(thrown)]=j;
				j++;
			}
		}
	}

	highlightSiteswap(siteswap){
		this.highlightSiteswapNumber(siteswap,1);		
	}

	highlightSiteswapNumber(siteswap,n){
		/*siteswap must be array*/
		/*highligh nodes and edges*/
		var curr = this.stateDiagram.findEdgeSequenceStartingNode(siteswap);
		for (var i = 0; i < siteswap.length;i++){
			/*edges */
			var thrown = siteswap[i];
			var edgeIndex = this.indexEdges[curr.getStateString()][thrown];
			var edgeEntry = this.edges[edgeIndex];
			edgeEntry["siteswap"+n]=true;
			/*nodes*/
			var nodeIndex = this.indexNodes[curr.getStateString()];
			var nodeEntry = this.nodes[nodeIndex];
			nodeEntry["siteswap"+n]=true;
			/*iterate to next node*/
			curr = curr.edges[thrown];
		}
	}

	highlightTransition(path){
		for (var i = 1; i < path.length-1; i++) {
			var edgeIndex = 
				this.indexEdges[path[i].node.getStateString()]
					[path[i].edge];
			var edgeEntry = this.edges[edgeIndex];
			edgeEntry["transition"]=true;

			var nodeIndex = 
				this.indexNodes[path[i].node.getStateString()];
			var nodeEntry = this.nodes[nodeIndex];
			nodeEntry["transition"]=true;
		}
		/*only draw an edge if there is an edge to draw*/
		if (path.length > 1){
			var edgeIndex = 
				this.indexEdges[path[i].node.getStateString()]
					[path[i].edge];
			var edgeEntry = this.edges[edgeIndex];
			edgeEntry["transition"]=true;
		}
	}

	transitionSiteswap(throwSequence1,throwSequence2){
		var nodeSequence1 = this.stateDiagram
			.findEdgeSequenceArray(throwSequence1);
		var nodeSequence2 = this.stateDiagram
			.findEdgeSequenceArray(throwSequence2);
		var path = this.stateDiagram
			.shortestPathFromNodes(nodeSequence1,nodeSequence2);
		/*when one node in path, they share a node*/
		/*when two, they share no nodes, but are connected by an edge*/
		/*nodes are listed in reverse,first node is in sequence2,
		last node is in sequence1*/
		this.highlightSiteswapNumber(throwSequence1,1);
		this.highlightSiteswapNumber(throwSequence2,2);
		this.highlightTransition(path);
	}

	cleanLayout(){
		var newNodes = [];
		var newEdges = [];
		var nodeMoves={};
		var j = 0;
		for (var i=0;i<this.nodes.length;i++){	
			if (this.nodes[i].transition ||
				this.nodes[i].siteswap1 ||
				this.nodes[i].siteswap2){
				newNodes.push(this.nodes[i]);
				nodeMoves[i] = j;
				j++;
			}
		}
		for (var i=0;i<this.edges.length;i++){
			if (this.edges[i].transition ||
				this.edges[i].siteswap1 ||
				this.edges[i].siteswap2){
				var edgeCopy = Object.assign({}, this.edges[i]);
				edgeCopy.source = nodeMoves[this.edges[i].source];
				edgeCopy.target = nodeMoves[this.edges[i].target];
				newEdges.push(edgeCopy);
			}
		}
		this.nodes = newNodes;
		this.edges = newEdges;
	}
}