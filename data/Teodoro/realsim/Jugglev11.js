/*
* Javascript Juggling 0.1 Copyright (c) 2006 Boris von Loesch
*
* Permission is hereby granted, free of charge, to any person obtaining a 
* copy of this software and associated documentation files (the "Software"), 
* to deal in the Software without restriction, including without limitation 
* the rights to use, copy, modify, merge, publish, distribute, sublicense, 
* and/or sell copies of the Software, and to permit persons to whom the 
* Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included 
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
* DEALINGS IN THE SOFTWARE.
*/

	function Ball (animator, ball) {
		//alert('ball')
		this.ball = ball;
		this.step = 0;
		this.ssw = 0;
		this.hand = -1;
		this.landhand = 0;
		this.height = 0;
		this.dwell=0;
		this.ctc=[0,0,0,0,0,0,0,0,0];
		this.z=100; //z coordinate
		this.animate = animateMe;
		this.animator = animator;
	}
	
	function Doll (animator, doll) {
		this.doll = doll;
		this.animate = animateMedoll;
		this.animator = animator;
	}
	
	function Lineup (animator, lineup) {
		this.step = 0;
		this.time = 0;
		this.dwell = 0;
		this.arm = 0; 
		this.type=1; //up
		this.ctc=[0,0,0,0,0,0,0,0,0];
		this.z=100; //z coordinate
		this.line = lineup;
		this.animate = animateMeline;
		this.animator = animator;
	}
	
	function Linedw (animator, linedw) {
		this.step = 0;
		this.time = 0;
		this.dwell = 0;
		this.arm = 0; 
		this.type=-1; //dw
		this.line = linedw;
		this.ctc=[0,0,0,0,0,0,0,0,0];
		this.z=100; //z coordinate
		this.animate = animateMeline;
		this.animator = animator;
	}

//--------------------------------------------------------
	function animateMedoll() {
		var animator = this.animator;
		
		this.doll.style.left=animator.centerx-animator.deltaX/2*animator.zoom + 'px';
		this.doll.style.bottom=animator.centery-animator.deltay*animator.zoom + 'px';
		this.doll.style.height=animator.deltaY*animator.zoom + 'px';
		this.doll.style.width=animator.deltaX*animator.zoom + 'px';
		this.doll.style.visibility = "visible";

		/*for (var i=0; i<animator.balls.length; i++){
			animator.container.insertBefore(animator.balls[i].ball,this.doll);
		}
		for (var i=0; i<animator.linedws.length; i++){
			animator.container.insertBefore(animator.linedws[i].line,this.doll);
		}
		for (var i=0; i<animator.lineups.length; i++){
			animator.container.insertBefore(animator.lineups[i].line,this.doll);
		}*/
		/*for (var i=0; i<animator.balls.length; i++){
			alert(animator.balls[i].z)
			if(animator.balls[i].z<0) {
				animator.container.insertBefore(animator.balls[i].ball,this.doll);
			}else{
				
				animator.container.insertBefore(this.doll,animator.balls[i].ball);
			}
		}*/
		/*for (var i=0; i<animator.linedws.length; i++){
			if(animator.linedws[i].z>0) {
				animator.container.insertBefore(this.doll,animator.linedws[i].ball);
			}else{
				animator.container.insertBefore(animator.linedws[i].line,this.doll);
			}
		}
		for (var i=0; i<animator.lineups.length; i++){
			if(animator.lineups[i].z>0) {
				animator.container.insertBefore(this.doll,animator.lineups[i].ball);
			}else{
				animator.container.insertBefore(animator.lineups[i].line,this.doll);
			}
		}*/

		
		
		
	}
	
	function animateMeline() {
		var animator = this.animator;
		var centerx = animator.centerx;
		var centery = animator.centery;
		var z=animator.zoom;
		var b=animator.ballSize*z/2;
		var A1x=centerx-animator.deltax*z;
		var A1y=centery;
		var A2x=centerx+animator.deltax*z;
		var A2y=centery;
		var dwell=this.dwell;

		if (this.arm==-1 && this.time>=this.step){ //left arm
			var c1x=centerx-this.ctc[0]*z;
			var c1y=centery+this.ctc[1]*z;
			var c1z=this.ctc[2];
			var t1x=centerx-this.ctc[3]*z;
			var t1y=centery+this.ctc[4]*z;
			var t1z=this.ctc[5];
			var c2x=centerx-this.ctc[6]*z;
			var c2y=centery+this.ctc[7]*z;
			var c2z=this.ctc[8];
			
			if (this.step < dwell) {
				var pos = interpolateBezier(this.step, dwell, c1x, c1y, c1z, t1x, t1y, t1z,-30*z);
			}else{
				var pos = interpolateBezier(this.step - dwell, this.time - dwell, t1x,t1y,t1z,c2x,c2y,c2z, 30*z);
			}
			//alert(this.step+'   '+c1x+'  '+c1y+'  '+t1x+'  '+t1y+'  '+c2x+'  '+c2y+'  '+pos)
			
			//		A1
			//   [/]
			// pos
			if (pos[0]<A1x && pos[1]<A1y) {
				this.line.style.left=pos[0]+'px';
				this.line.style.bottom=pos[1]+'px';
				this.line.style.width=A1x-pos[0]+'px';
				this.line.style.height=A1y-pos[1]+'px';
				if (this.type==1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//		pos
			//   [/]
			// A1
			if (pos[0]>A1x && pos[1]>A1y) {
				this.line.style.left=A1x+'px';
				this.line.style.bottom=A1y+'px';
				this.line.style.width=pos[0]-A1x+'px';
				this.line.style.height=pos[1]-A1y+'px';
				if (this.type==1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//  A1
			//   [\]
			// 		pos
			if (pos[0]>A1x && pos[1]<A1y) {
				this.line.style.left=A1x+'px';
				this.line.style.bottom=pos[1]+'px';
				this.line.style.width=pos[0]-A1x+'px';
				this.line.style.height=A1y-pos[1]+'px';
				if (this.type==-1) { //line dw
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//  pos
			//   [\]
			// 		A1
			if (pos[0]<A1x && pos[1]>A1y) {
				this.line.style.left=pos[0]+'px';
				this.line.style.bottom=A1y+'px';
				this.line.style.width=A1x-pos[0]+'px';
				this.line.style.height=pos[1]-A1y+'px';
				if (this.type==-1) { //line dw
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
		}
		
		if (this.arm==1 && this.time>this.step){ //right arm
			var c1x=centerx+this.ctc[0]*z;
			var c1y=centery+this.ctc[1]*z;
			var c1z=this.ctc[2];
			var t1x=centerx+this.ctc[3]*z;
			var t1y=centery+this.ctc[4]*z;
			var t1z=this.ctc[5];
			var c2x=centerx+this.ctc[6]*z;
			var c2y=centery+this.ctc[7]*z;
			var c2z=this.ctc[8];
			
			
			if (this.step < dwell) {
				var pos = interpolateBezier(this.step, dwell, c1x, c1y, c1z, t1x, t1y, t1z,-30*z);
			}else{
				var pos = interpolateBezier(this.step - dwell, this.time - dwell, t1x,t1y,t1z,c2x,c2y,c2z, 30*z);
			}
			//alert(this.step+'   '+c1x+'  '+c1y+'  '+t1x+'  '+t1y+'  '+c2x+'  '+c2y+'  '+pos)
			/*if(pos[2]<0){
					
				animator.container.insertBefore(this.line,animator.dolls[0].doll);
	
			}else{
				animator.container.insertBefore(animator.dolls[0].doll,this.line);
	
			}*/
			//		A1
			//   [/]
			// pos
			if (pos[0]<A2x && pos[1]<A2y) {
				this.line.style.left=pos[0]+'px';
				this.line.style.bottom=pos[1]+'px';
				this.line.style.width=A2x-pos[0]+'px';
				this.line.style.height=A2y-pos[1]+'px';
				if (this.type==1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//		pos
			//   [/]
			// A1
			if (pos[0]>A2x && pos[1]>A2y) {
				this.line.style.left=A2x+'px';
				this.line.style.bottom=A2y+'px';
				this.line.style.width=pos[0]-A2x+'px';
				this.line.style.height=pos[1]-A2y+'px';
				if (this.type==1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//  A1
			//   [\]
			// 		pos
			if (pos[0]>A2x && pos[1]<A2y) {
				this.line.style.left=A2x+'px';
				this.line.style.bottom=pos[1]+'px';
				this.line.style.width=pos[0]-A2x+'px';
				this.line.style.height=A2y-pos[1]+'px';
				if (this.type==-1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
			//  pos
			//   [\]
			// 		A1
			if (pos[0]<A2x && pos[1]>A2y) {
				this.line.style.left=pos[0]+'px';
				this.line.style.bottom=A2y+'px';
				this.line.style.width=A2x-pos[0]+'px';
				this.line.style.height=pos[1]-A2y+'px';
				if (this.type==-1) { //line up
					this.line.style.visibility = "visible";
				}else{
					this.line.style.visibility = "hidden";
				}
			}
		}
		if(this.time>this.step){
			this.z=pos[2];
		}
				this.step+=1;

	}
	

	
	
	function animateMe() {
		//alert('animateMe' + this.step)
		var animator = this.animator;
		if (this.ssw == 0) {
			this.ball.style.visibility = "hidden";
			return;
		}
		else if (this.step == 0) this.ball.style.visibility = "visible";
		
		var centerx = animator.contWidth/2;
		var centery = animator.yCoord;
		var z=animator.zoom;
		
		if (this.hand==-1){
			var c1x = centerx - this.ctc[0]*z;
			var c1y = centery + this.ctc[1]*z;
			var c1z = this.ctc[2];
			var t1x = centerx - this.ctc[3]*z;
			var t1y = centery + this.ctc[4]*z;
			var t1z = this.ctc[5];
		}else{
			var c1x = centerx + this.ctc[0]*z;
			var c1y = centery + this.ctc[1]*z;
			var c1z = this.ctc[2];
			var t1x = centerx + this.ctc[3]*z;
			var t1y = centery + this.ctc[4]*z;
			var t1z = this.ctc[5];		
		}
		if (this.landhand==-1){
			var c2x = centerx - this.ctc[6]*z;
			var c2y = centery + this.ctc[7]*z;
			var c2z = this.ctc[8];
		}else{
			var c2x = centerx + this.ctc[6]*z;
			var c2y = centery + this.ctc[7]*z;
			var c2z = this.ctc[8];		
		}
		
		var pos;
		var dwell=this.dwell;
		if (this.step < dwell) {
			pos = interpolateBezier(this.step, dwell, c1x, c1y, c1z, t1x, t1y, t1z, -30*Math.sqrt(this.ssw)*z);

		}else{
			pos = getThrowCoord(this.step - dwell, this.ssw * animator.resolution - dwell, animator.T, t1x,t1y,t1z,c2x,c2y,c2z, this.height);

		}
		
		if (t1z<0 || c2z<0) {
			if(pos[2]<0){
					
				animator.container.insertBefore(this.ball,animator.dolls[0].doll);
	
			}else{
				animator.container.insertBefore(animator.dolls[0].doll,this.ball);
	
			}
		}

		var bz=(1-(200-pos[2])/1100)*z;
		var b=animator.ballSize/2*bz;
		this.ball.style.left = pos[0]-b + 'px';
		this.ball.style.bottom = pos[1] + 'px';
		this.ball.style.height=animator.ballSize*bz+"px";
		this.ball.style.width=animator.ballSize*bz+"px";
		if(this.step>0){
			this.z=pos[2];
		}
		this.step += 1;
		//alert(this.step + '   ' + pos + '   '  + this.ssw + '  ' +this.hand+'   '+this.landhand);
		
	}


/*
 * -------------------------------------------------------------------------------------------
 */

	function SiteswapAnimator(viewport) {
		//alert('SiteswapAnimator')
		this.id = SiteswapAnimator.instances.length;
		//alert('container:' + this.id)
		SiteswapAnimator.instances[this.id] = this;
		this.container = viewport;
		//Get the width of the container
		var css;
		if (this.container.currentStyle == null) css = window.getComputedStyle(this.container, null);
		else css = this.container.currentStyle;
		this.contWidth = parseInt(css.width);
		this.contHeight = parseInt(css.height);
		this.tsec= 4;
		this.speed = 40/(this.tsec);
		
		this.resolution = 20;
		this.dwell = 0.6;
		this.dwellSteps = Math.round(this.dwell * this.resolution);

		this.ballSize = 40;
		this.ballPicture = "ball.gif";
		this.dollPicture = "doll5.gif";
		this.linedwPicture = "linedw.gif";
		this.lineupPicture = "lineup.gif";

		this.normal = 0;
		this.deltax = 97;
		this.deltaX = 200;
		this.centerx = parseInt(css.width)/2;
		
		this.deltay = 40;
		this.deltaY = 330;
		this.yCoord = 150; //BALL ZERO REFERENTIAL;
		this.centery = this.yCoord;
		
		this.zoom=1;
		this.real=0;
		this.skill=1;
		this.T = 4;
		
		this.SSL=new Array(); //SS array for left hand
		this.SSLX=new Array(); //cross throws array for left hand (1=normal; -1=cross)
		this.SSR=new Array(); //SS array for right hand
		this.SSRX=new Array(); //cross throws array for right hand (1=normal; -1=cross)
		this.TB=new Array(); //TimeBeat array
		this.RL=new Array(); //right line (hand) move steps
		this.LL=new Array(); //left line (hand) move steps
		
		this.RC1x=new Array(); //catch position (ball=arm)
		this.RT1x=new Array(); //throw position (ball=arm)
		this.RC2Ax=new Array(); //catch position for the following ball
		this.RC2Bx=new Array(); //catch positionn for the landing ball
		
		this.RC1y=new Array(); //catch position (ball=arm)
		this.RT1y=new Array(); //throw position (ball=arm)
		this.RC2Ay=new Array(); //catch position for the following ball
		this.RC2By=new Array(); //catch positionn for the landing ball
		
		this.RC1z=new Array(); //catch position (ball=arm)
		this.RT1z=new Array(); //throw position (ball=arm)
		this.RC2Az=new Array(); //catch position for the following ball
		this.RC2Bz=new Array(); //catch positionn for the landing ball
		
		this.LC1x=new Array(); //catch position (ball=arm)
		this.LT1x=new Array(); //throw position (ball=arm)
		this.LC2Ax=new Array(); //catch position for the following ball
		this.LC2Bx=new Array(); //catch positionn for the landing ball
		
		this.LC1y=new Array(); //catch position (ball=arm)
		this.LT1y=new Array(); //throw position (ball=arm)
		this.LC2Ay=new Array(); //catch position for the following ball
		this.LC2By=new Array(); //catch positionn for the landing ball
		
		this.LC1z=new Array(); //catch position (ball=arm)
		this.LT1z=new Array(); //throw position (ball=arm)
		this.LC2Az=new Array(); //catch position for the following ball
		this.LC2Bz=new Array(); //catch positionn for the landing ball
		
		this.ssw = "0";
		this.number = 0;
		this.timer = null;
		this.balls = null;
		this.dolls = null;
		this.lineup= null;
		this.linedw=null;
		this.step = 0;
		this.sswStep = 0;
		this.maxThrow = 0;
		this.style = "0";
		this.styleleft= new Array();
		this.styleright= new Array();
						
		//Functions
		this.setSiteswap = setSiteswap;
		this.checkSiteswap = checkSiteswap;
		
		this.destroyBalls = destroyBalls;
		this.destroyDolls = destroyDolls;
		this.destroyLineups = destroyLineups;
		this.destroyLinedws = destroyLinedws;
		this.createBalls = createBalls;
		this.createDolls = createDolls;
		this.createLineups = createLineups;
		this.createLinedws = createLinedws;
		
		this.getHeight = getHeight;
		this.getNextBall = getNextBall;
		this.animate = animate;
		this.startAnimation = startAnimation;
		this.stopAnimation = stopAnimation;
		
	}
 	SiteswapAnimator.instances = new Array()	

		
	
	
	
	function destroyBalls() {
		if (this.balls != null) {
			for (var i = 0; i < this.balls.length; i++) {
				this.container.removeChild(this.balls[i].ball);
			}
			this.balls = null;
		}
	}
	
	function destroyDolls() {
		if (this.dolls != null) {
			for (var i = 0; i < this.dolls.length; i++) {
				this.container.removeChild(this.dolls[i].doll);
			}
			this.dolls = null;
		}
	}
	
	function destroyLineups() {
		if (this.lineups != null) {
			for (var i = 0; i < this.lineups.length; i++) {
				this.container.removeChild(this.lineups[i].line);
			}
			this.lineups = null;
		}
	}
	
	function destroyLinedws() {
		if (this.linedws != null) {
			for (var i = 0; i < this.linedws.length; i++) {
				this.container.removeChild(this.linedws[i].line);
			}
			this.linedws = null;
		}
	}
	

	function createBalls () {
		this.balls = new Array(this.number);
		for (var i = 0; i < this.number; i++) {
			var img = document.createElement("img");
			img.className = "ball";
			img.src = this.ballPicture;
			img.id = "ball"+i;
			img.style.left = "0px";
			img.style.bottom = "0px";
			img.style.height ="10px";
			img.style.width = "10px";
			this.balls[i] = new Ball(this, img);
			this.container.appendChild(img);
		}
	}

	function createDolls () {
		this.dolls = new Array(1);
		for (var i = 0; i < 1; i++) {
			var img = document.createElement("img");
			img.className = "doll";
			img.src = this.dollPicture;
			img.id = "doll"+i;
			img.style.left = "0px";
			img.style.bottom = "0px";
			img.style.height ="100px";
			img.style.width = "80px";
			this.dolls[i] = new Doll(this, img);
			this.container.appendChild(img);
		}
	}
	
	function createLineups () {
		this.lineups = new Array(1);
		for (var i = 0; i < 2; i++) {
			var img = document.createElement("img");
			img.className = "lineup";
			img.src = this.lineupPicture;
			img.id = "lineup"+i;
			img.style.left = "0px";
			img.style.bottom = "0px";
			img.style.height ="30px";
			img.style.width = "30px";
			this.lineups[i] = new Lineup(this, img);
			this.container.appendChild(img);
		}
	}
	
	function createLinedws () {
		this.linedws = new Array(1);
		for (var i = 0; i < 2; i++) {
			var img = document.createElement("img");
			img.className = "linedw";
			img.src = this.linedwPicture;
			img.id = "linedw"+i;
			img.style.left = "0px";
			img.style.bottom = "0px";
			img.style.height ="30px";
			img.style.width = "30px";
			this.linedws[i] = new Linedw(this, img);
			this.container.appendChild(img);
		}
	}
	
	function getHeight(position) {
		//alert('getHeight')
		//var s = parseInt(this.ssw.charCodeAt(position % this.ssw.length));
		var s=this.SS[position % this.SS.length];
		return s
		//return parseInt(this.ssw.charAt(position % this.ssw.length));
	}
	
	function getNextBall(landhand) {
		//alert('getNextBall')
		for (var i = 0; i < this.number; i++) {
			//alert(i + ' : ' + this.balls[i].ssw  +' : ' + this.resolution +' : '+ ssw)
			if (this.balls[i].landhand==0) {
					if (this.balls[i].step == this.balls[i].ssw * this.resolution) return i;
			}else{
					if (this.balls[i].step == this.balls[i].ssw * this.resolution && this.balls[i].landhand==landhand) return i;
			}
		}
		return -1;
	}
	
	function animate() {
		//alert(this.style)
		this.lineups[0].arm=-1;
		this.linedws[0].arm=-1;
		this.lineups[1].arm=1;
		this.linedws[1].arm=1;
		if (this.step % this.resolution == 0) { //ball(s) landed

			
			/*if(this.step==200){
				
				this.container.insertBefore(this.balls[0].ball,this.dolls[0].doll);


			}else if(this.step==400){
				this.container.insertBefore(this.dolls[0].doll,this.balls[0].ball);


			}*/
			
			var tb = this.sswStep%(this.TB[this.TB.length-1]+1); //tb throw
			
			if (this.LL[tb]>0){
					this.lineups[0].step=0;
					this.lineups[0].time=this.LL[tb];
					this.lineups[0].ctc=[this.LC1x[tb], this.LC1y[tb], this.LC1z[tb], this.LT1x[tb], this.LT1y[tb], this.LT1z[tb], this.LC2Ax[tb], this.LC2Ay[tb], this.LC2Az[tb]];
					this.linedws[0].step=0;
					this.linedws[0].time=this.LL[tb];
					this.linedws[0].ctc=[this.LC1x[tb], this.LC1y[tb], this.LC1z[tb], this.LT1x[tb], this.LT1y[tb], this.LT1z[tb], this.LC2Ax[tb], this.LC2Ay[tb], this.LC2Az[tb]];
					if (this.RL[tb]>0){
						this.lineups[0].dwell=this.dwell*Math.min(this.LL[tb],this.RL[tb]);
						this.linedws[0].dwell=this.dwell*Math.min(this.LL[tb],this.RL[tb]);
					}else{
						this.lineups[0].dwell=this.dwell*this.LL[tb];
						this.linedws[0].dwell=this.dwell*this.LL[tb];	
					}
					this.lineups[0].dwell=Math.min(this.resolution*2*this.dwell,this.lineups[0].dwell);
					this.linedws[0].dwell=Math.min(this.resolution*2*this.dwell,this.linedws[0].dwell);
			}
			if (this.RL[tb]>0){
					this.lineups[1].step=0;
					this.lineups[1].time=this.RL[tb];
					this.lineups[1].ctc=[this.RC1x[tb], this.RC1y[tb], this.RC1z[tb], this.RT1x[tb], this.RT1y[tb], this.RT1z[tb], this.RC2Ax[tb], this.RC2Ay[tb], this.RC2Az[tb]];
					this.linedws[1].step=0;
					this.linedws[1].time=this.RL[tb];
					this.linedws[1].ctc=[this.RC1x[tb], this.RC1y[tb], this.RC1z[tb], this.RT1x[tb], this.RT1y[tb], this.RT1z[tb], this.RC2Ax[tb], this.RC2Ay[tb], this.RC2Az[tb]];
					if (this.LL[tb]>0){
						this.lineups[1].dwell=this.dwell*Math.min(this.LL[tb],this.RL[tb]);
						this.linedws[1].dwell=this.dwell*Math.min(this.LL[tb],this.RL[tb]);
					}else{
						this.lineups[1].dwell=this.dwell*this.RL[tb];
						this.linedws[1].dwell=this.dwell*this.RL[tb];	
					}
					this.lineups[1].dwell=Math.min(this.resolution*2*this.dwell,this.lineups[1].dwell);
					this.linedws[1].dwell=Math.min(this.resolution*2*this.dwell,this.linedws[1].dwell);
			}
			//alert(this.lineups[0].dwell+'  '+this.lineups[1].dwell+'  '+this.LL[tb]+'  '+this.RL[tb]);

			for (var j = 0; j < this.TB.length; j++) {
				if(this.TB[j]==tb){					
					var height_lefthand = this.SSL[j];
					var height_righthand = this.SSR[j]; //this.getHeight(this.sswStep);
					//alert(height_lefthand + ',' + height_righthand)
					if (height_lefthand != 0) {
						var i = this.getNextBall(-1);
						if (i == -1){
							this.stopAnimation();
							alert ("Fehler");
							return;
						}
						if (height_lefthand<3){
							this.balls[i].height=0;
						}else{
							this.balls[i].height=height_lefthand;
						}
						var rand=Math.random();
						this.balls[i].height=this.balls[i].height+(1-this.skill)*1.5*(0.5-rand);
						if (height_lefthand==1){
							this.lineups[0].dwell=this.resolution*this.dwell;
							this.linedws[0].dwell=this.resolution*this.dwell;
						}
						this.balls[i].ssw = height_lefthand;
						this.balls[i].height=this.balls[i].height*5/this.tsec;
						this.balls[i].step = 0;
						this.balls[i].hand = -1;
						this.balls[i].landhand=Math.pow(-1,height_lefthand+1)*this.SSLX[j];
						this.balls[i].dwell=this.lineups[0].dwell;
						this.balls[i].ctc=[this.LC1x[tb], this.LC1y[tb], this.LC1z[tb], this.LT1x[tb], this.LT1y[tb], this.LT1z[tb], this.LC2Bx[j], this.LC2By[j], this.LC2Bz[j]];
					}
					if (height_righthand != 0) {
						var i = this.getNextBall(1);
						if (i == -1){
							this.stopAnimation();
							alert ("Ops! Bad SS");
							return;
						}
						if (height_righthand<3){
							this.balls[i].height=0;
						}else{
							this.balls[i].height=height_righthand;
						}
						var rand=Math.random();
						this.balls[i].height=this.balls[i].height+(1-this.skill)*1.5*(0.5-rand);
						if (height_righthand==1){
							this.lineups[1].dwell=this.resolution*this.dwell;
							this.linedws[1].dwell=this.resolution*this.dwell;
						}
						this.balls[i].ssw = height_righthand;
						this.balls[i].height=this.balls[i].height*5/this.tsec;
						this.balls[i].step = 0;
						this.balls[i].hand = 1;
						this.balls[i].landhand=Math.pow(-1,height_righthand)*this.SSRX[j];
						this.balls[i].dwell=this.lineups[1].dwell;
						this.balls[i].ctc=[this.RC1x[tb], this.RC1y[tb], this.RC1z[tb], this.RT1x[tb], this.RT1y[tb], this.RT1z[tb], this.RC2Bx[j], this.RC2By[j], this.RC2Bz[j]];
					}
				}
			}
			this.sswStep++;
		}
		this.linedws[0].animate();
		this.lineups[0].animate();
		this.linedws[1].animate();
		this.lineups[1].animate()
		for (var i = 0; i < this.number; i++) {
			this.balls[i].animate(); //animateMe (ball i)
		}
				this.dolls[0].animate();

		this.step++;
	}
	
	function stopAnimation() {
		//alert('stopAnimation')
		clearInterval(this.timer);
	}
	
	function startAnimation() {
		//alert('startAnimation')
		var o = this;
		this.balls[0].ball.style.visibility = "visible";
		this.dolls[0].doll.style.visibility = "visible";
		this.lineups[0].line.style.visibility = "visible";
		this.linedws[0].line.style.visibility = "visible";
		this.timer = setInterval('SiteswapAnimator.instances[' + this.id + '].animate();', this.speed);
	}
	
/*
 * -------------------------------------------------------------------------------------------
 */

	/**
	 * Static function
	 */
	function interpolateBezier(step, cStep, startx, starty, startz,endx, endy, endz,oben) {
		//trajéctória da bola: 0(step) -> cStep
		//startx,starty: posição de lançamento da bola
		//endx,endy: posição de catch da bola
		//oben: throw (high)
		
		//paramentric time (0->1)
		var t = step / (cStep * 1.0);
		
		//tempo restante (1->0)
		var u = 1 - t;
		
		//u^3+3*u^2*t+3*u*t^2+t^3
		var tuTriple = 3 * t * u;
		var c0 = u * u * u;
		var c1 = tuTriple * u;
		var c2 = tuTriple * t;
		var c3 = t * t * t;
		cogx = (startx + endx) / 2.0; 
		cogy = (starty + endy) / 2.0 + oben;
		cogz = (startz + endz) / 2.0;
		x = c0 * startx + c1 * cogx + c2 * cogx + c3 * endx;
		y = c0 * starty + c1 * cogy + c2 * cogy + c3 * endy;
		z = c0 * startz + c1 * cogz + c2 * cogz + c3 * endz;
		var pos = new Array(3);
		pos[0] = x; pos[1] = y; pos[2] = z;
		//alert('bz '+pos)
		return pos;
	}

	/**
	 * Static function
	 */
	function getThrowCoord (step, cStep, T, startx, starty, startz, endx, endy, endz, height) {
		var t = (height - 1.0) * T;
		if (height == 3) t = (3.5 - 1.0) * T;
		var h = (9.81 * t * t) / 10.0;
		var st = 1.0*step / cStep;
		x = startx + st * (endx - startx);
		y = starty + (st * (endy - starty)) - 4.0 * h * (st * st - st);
		z = startz + st * (endz - startz);

		var pos = new Array(3);
		pos[0] = x;
		pos[1] = y;
		pos[2] = z;
		//alert('pb '+pos)
		return pos;
	}
	
	/**
	 * Creates and starts the siteswap animation
	 */
	function setSiteswap (ssw, resolution, style,tsec,skill) {
		//alert(style)
		this.style=style;
		this.ballPicture = "ball3.gif";
		this.dollPicture = "dollreal.png";
		this.linedwPicture = "linedwreal.gif";
		this.lineupPicture = "lineupreal.gif";
		
		this.deltaX = 240;
		this.deltay = 40;
		if (this.style=="(150,70);(150,70)"){
			this.normal=1;
			
		}else{
			this.normal=0;
		}
		//alert(this.normal)
		this.resolution = parseInt(600/resolution+5);
		this.dwellSteps = Math.round(this.dwell * resolution);
		this.tsec=tsec*1-0.3;
		this.skill=skill/40+0.5;
		//alert(this.skill)
		
		
		this.ssw = ssw;
		this.stopAnimation();
		this.destroyBalls();
		this.destroyDolls();
		this.destroyLineups();
		this.destroyLinedws();
		this.SSL=new Array(); //SS array for left hand
		this.SSLX=new Array(); //cross throws array for left hand (1=normal; -1=cross)
		this.SSR=new Array(); //SS array for right hand
		this.SSRX=new Array(); //cross throws array for right hand (1=normal; -1=cross)
		this.TB=new Array(); //TimeBeat array
		this.ballSize = 40;
		this.speed=40/this.tsec;
		this.zoom=1;
		
		
		this.T = 4;
		
		this.SSL=new Array(); //SS array for left hand
		this.SSLX=new Array(); //cross throws array for left hand (1=normal; -1=cross)
		this.SSR=new Array(); //SS array for right hand
		this.SSRX=new Array(); //cross throws array for right hand (1=normal; -1=cross)
		this.TB=new Array(); //TimeBeat array
		this.RL=new Array(); //right line (hand) move steps
		this.LL=new Array(); //left line (hand) move steps
		
		this.RC1x=new Array(); //catch position (ball=arm)
		this.RT1x=new Array(); //throw position (ball=arm)
		this.RC2Ax=new Array(); //catch position for the following ball
		this.RC2Bx=new Array(); //catch positionn for the landing ball
		
		this.RC1y=new Array(); //catch position (ball=arm)
		this.RT1y=new Array(); //throw position (ball=arm)
		this.RC2Ay=new Array(); //catch position for the following ball
		this.RC2By=new Array(); //catch positionn for the landing ball
		
		this.RC1z=new Array(); //catch position (ball=arm)
		this.RT1z=new Array(); //throw position (ball=arm)
		this.RC2Az=new Array(); //catch position for the following ball
		this.RC2Bz=new Array(); //catch positionn for the landing ball
		
		this.LC1x=new Array(); //catch position (ball=arm)
		this.LT1x=new Array(); //throw position (ball=arm)
		this.LC2Ax=new Array(); //catch position for the following ball
		this.LC2Bx=new Array(); //catch positionn for the landing ball
		
		this.LC1y=new Array(); //catch position (ball=arm)
		this.LT1y=new Array(); //throw position (ball=arm)
		this.LC2Ay=new Array(); //catch position for the following ball
		this.LC2By=new Array(); //catch positionn for the landing ball
		
		this.LC1z=new Array(); //catch position (ball=arm)
		this.LT1z=new Array(); //throw position (ball=arm)
		this.LC2Az=new Array(); //catch position for the following ball
		this.LC2Bz=new Array(); //catch positionn for the landing ball
		if (this.checkSiteswap() == false) alert (this.ssw+" is no valid siteswap!");
		else {
			//Control throw height
			this.T = 4;
			var h = Math.sqrt((this.contHeight - this.yCoord)/
				((this.maxThrow+0.7 - 1.0)*(this.maxThrow+0.7 - 1.0)*4/(this.tsec-1.5)));
			if (h < this.T){
				 this.zoom=(h-1)/(this.T-0.5);
				 if(this.zoom<0.08){
					 this.zoom=0.08;
				 }
				 //this.zoom=Math.min(1,this.zoom-(1-this.tsec/5.5)*this.zoom);
				 this.T = h;
			}

			this.createDolls();
			this.createLineups();
			this.createLinedws();
			this.createBalls();			
			this.step = 0;
			this.sswStep = 0;
		}
	}

	/**
	 * Check siteswap and calculate number of balls
	 * and the maximal height
	 */
	function checkSiteswap() {
		//alert('checkSiteswap')
		if (this.ssw.length == 0) return false;
		var buffer;
		this.maxThrow = 0;
		var hand=-1; //-1=left; 1=right
		var k=-1;
		var tb=-1; //timebeat
		var asc=[0,0,0,0,0,0,0,0]; //asc=asciicode = ! ( ) * , [ ] x
		for (var i = 0; i < this.ssw.length; i++) {
			
			//take each char and converts to ASCII CODE
			var s = parseInt(this.ssw.charCodeAt(i));
			//   ! -> 33
			//   ( -> 40
			//   ) -> 41
			//   * -> 42
			//   , -> 44
			//   [ -> 91
			//   ] -> 93
			//   x -> 120
			//   0-9   -> 48-57
			//   a-z   -> 97-122
			//   A-Z   -> 65-90
			//   ; -> 59
			
			//test single throw
			if (s>47 && s<58) {
				tb++
				k++
				if (hand == -1) {//left
					this.SSL[k]=s-48;
					this.SSR[k]=0;
					if (parseInt(this.ssw.charCodeAt(i+1))==120){
						this.SSLX[k]=-1;
						i++;
					}else{
						this.SSLX[k]=1;
					}
					this.SSRX[k]=0;
				}else{
					this.SSL[k]=0;
					this.SSR[k]=s-48;
					if (parseInt(this.ssw.charCodeAt(i+1))==120){
						this.SSRX[k]=-1;
						i++;
					}else{
						this.SSRX[k]=1;
					}
					this.SSLX[k]=0;
				}
				this.TB[k]=tb;
				hand=hand*-1;
			}else if (s>96 && s<120){
				tb++
				k++
				if (hand == -1){ //left
					this.SSL[k]=s-87;
					this.SSR[k]=0;
					if (parseInt(this.ssw.charCodeAt(i+1))==120){
						this.SSLX[k]=-1;
						i++;
					}else{
						this.SSLX[k]=1;
					}
					this.SSRX[k]=0;
				}else{
					this.SSL[k]=0;
					this.SSR[k]=s-87;
					if (parseInt(this.ssw.charCodeAt(i+1))==120){
						this.SSRX[k]=-1;
						i++;
					}else{
						this.SSRX[k]=1;
					}
					this.SSLX[k]=0;
				}
				this.TB[k]=tb;
				hand=hand*-1;
			}
			
			//test multyplex []
			else if (s==91) {
				tb++;
				while(s!=93){
					i++;
					s = parseInt(this.ssw.charCodeAt(i))
					if(s==93){break}
					if (s>47 && s<58) {
						k++
						if (hand == -1) {//left
							this.SSL[k]=s-48;
							this.SSR[k]=0;
							if (parseInt(this.ssw.charCodeAt(i+1))==120){
								this.SSLX[k]=-1;
								i++;
							}else{
								this.SSLX[k]=1;
							}
							this.SSRX[k]=0;
						}else{
							this.SSL[k]=0;
							this.SSR[k]=s-48;
							if (parseInt(this.ssw.charCodeAt(i+1))==120){
								this.SSRX[k]=-1;
								i++;
							}else{
								this.SSRX[k]=1;
							}
							this.SSLX[k]=0;
						}
						this.TB[k]=tb;
					}else if (s>96 && s<120){
						k++
						if (hand == -1){ //left
							this.SSL[k]=s-87;
							this.SSR[k]=0;
							if (parseInt(this.ssw.charCodeAt(i+1))==120){
								this.SSLX[k]=-1;
								i++;
							}else{
								this.SSLX[k]=1;
							}
							this.SSRX[k]=0;
						}else{
							this.SSL[k]=0;
							this.SSR[k]=s-87;
							if (parseInt(this.ssw.charCodeAt(i+1))==120){
								this.SSRX[k]=-1;
								i++;
							}else{
								this.SSRX[k]=1;
							}
							this.SSLX[k]=0;
						}
						this.TB[k]=tb;
					}else{
						return false
					}
				}
				hand=hand*-1;
			}
			
			//test sync (,)
			else if (s==40) {
				tb++
				kl=k; //k for left
				kr=k; //k for right
				while(s!=44){ // ,
					i++;
					s = parseInt(this.ssw.charCodeAt(i))
					if(s==44){break}
					//test single throw
					if (s>47 && s<58) {
						kl++
						this.SSL[kl]=s-48;
						this.SSR[kl]=0;
						if (parseInt(this.ssw.charCodeAt(i+1))==120){
							this.SSLX[kl]=-1;
							i++;
						}else{
							this.SSLX[kl]=1;
						}
						this.SSRX[kl]=0;
						this.TB[kl]=tb;
					}else if (s>96 && s<120){
						kl++
						this.SSL[kl]=s-87;
						this.SSR[kl]=0;
						if (parseInt(this.ssw.charCodeAt(i+1))==120){
							this.SSLX[kl]=-1;
							i++;
						}else{
							this.SSLX[kl]=1;
						}
						this.SSRX[kl]=0;
						this.TB[kl]=tb;
					}
					
					//test multyplex []
					if (s==91) {
						while(s!=93){
							i++;
							s = parseInt(this.ssw.charCodeAt(i))
							if(s==93){break}
							if (s>47 && s<58) {
								kl++
								this.SSL[kl]=s-48;
								this.SSR[kl]=0;
								if (parseInt(this.ssw.charCodeAt(i+1))==120){
									this.SSLX[kl]=-1;
									i++;
								}else{
									this.SSLX[kl]=1;
								}
								this.SSRX[kl]=0;					
								this.TB[kl]=tb;
							}else if (s>96 && s<120){
								k++
								this.SSL[kl]=s-87;
								this.SSR[kl]=0;
								if (parseInt(this.ssw.charCodeAt(i+1))==120){
									this.SSLX[kl]=-1;
									i++;
								}else{
									this.SSLX[kl]=1;
								}
								this.SSRX[kl]=0;
								this.TB[kl]=tb;
							}else{
								return false
							}
						}
					}
				}
				while(s!=41){ // )
					i++;
					s = parseInt(this.ssw.charCodeAt(i))
					if(s==41){break}
					//test single throw
					if (s>47 && s<58) {
						kr++
						this.SSR[kr]=s-48;
						if (parseInt(this.ssw.charCodeAt(i+1))==120){
							this.SSRX[kr]=-1;
							i++;
						}else{
							this.SSRX[kr]=1;
						}
						if (kr>kl){
							this.SSL[kr]=0;
							this.SSLX[kr]=0;
							this.TB[kr]=tb;
						}
					}else if (s>96 && s<120){
						kr++
						this.SSR[kr]=s-87;
						if (parseInt(this.ssw.charCodeAt(i+1))==120){
							this.SSRX[kr]=-1;
							i++;
						}else{
							this.SSRX[kr]=1;
						}
						if (kr>kl){
							this.SSL[kr]=0;
							this.SSLX[kr]=0;
							this.TB[kr]=tb;
						}
					}
					
					//test multyplex []
					if (s==91) {
						while(s!=93){
							i++;
							s = parseInt(this.ssw.charCodeAt(i))
							if(s==93){break}
							if (s>47 && s<58) {
								kr++
								this.SSR[kr]=s-48;
								if (parseInt(this.ssw.charCodeAt(i+1))==120){
									this.SSRX[kr]=-1;
									i++;
								}else{
									this.SSRX[kr]=1;
								}
								if (kr>kl){
									this.SSL[kr]=0;
									this.SSLX[kr]=0;
									this.TB[kr]=tb;
								}	
							}else if (s>96 && s<120){
								kr++
								this.SSR[kr]=s-87;
								if (parseInt(this.ssw.charCodeAt(i+1))==120){
									this.SSRX[kr]=-1;
									i++;
								}else{
									this.SSRX[kr]=1;
								}
								if (kr>kl){
									this.SSL[kr]=0;
									this.SSLX[kr]=0;
									this.TB[kr]=tb;
								}
							}else{
								return false
							}
						}
					}
				}
				if (kr>kl) {
					k=kr;
				} else {
					k=kl;
				}
				if (parseInt(this.ssw.charCodeAt(i+1))==33){
					hand=hand*-1;
					i++;
				}else{
					k++
					tb++
					this.SSL[k]=0;
					this.SSR[k]=0;
					this.SSLX[k]=0;
					this.SSRX[k]=0;
					this.TB[k]=tb;	
					hand=-1;
				}
			}
			
			//alert(this.SSL + ' : ' + this.SSR + ' : ' + this.SSLX + ' : ' + this.SSRX + ' : ' + this.TB)
			
			//check siteswap using mod: 645-021
			/*buffer = (s + i) % this.ssw.length;
			if (buf[buffer] == true) return false;
			else buf[buffer] = true;*/
			buffer=false;
		}
		
		//mirrow the siteswap if the next of the last throw is different to the first hand throw
		if (hand==1 || parseInt(this.ssw.charCodeAt(this.ssw.length-1))==42){
			var len=this.SSL.length;
			for (var i = 0; i < len; i++) {
				this.SSL[len+i]=this.SSR[i];
				this.SSR[len+i]=this.SSL[i];
				this.SSLX[len+i]=this.SSRX[i];
				this.SSRX[len+i]=this.SSLX[i];
				this.TB[len+i]=this.TB[i]+tb+1;
			}		
		}

		//calculate maxthrow and number of balls
		var len=this.SSL.length;
		var sumt=0;
		var maxt=0;
		for (var i = 0; i < len; i++) {
			sumt=sumt+this.SSL[i]+this.SSR[i];
			if (this.SSL[i]>maxt) {
				maxt=this.SSL[i];
			}
			if (this.SSR[i]>maxt) {
				maxt=this.SSR[i];
			}
		}
		this.maxThrow=maxt;
		this.number=sumt/(this.TB[len-1]+1);
		
		//line hand moves cicles

		for (var i = 0; i < this.TB[len-1]+1; i++) {

			for (var j = 0; j < this.TB.length; j++) {
				
					if(this.TB[j]==i){
					if (this.SSL[j]>0 || this.LL[i]>0) {
						this.LL[i]=1;
					}else{
						this.LL[i]=0;
					}
					if (this.SSR[j]>0 || this.RL[i]>0) {
						this.RL[i]=1;
					}else{
						this.RL[i]=0;
					}
				}
			}
		}
		
		if (this.normal==1) {
			var minimum=10000;
		}else{
			var minimum=this.resolution*2;
		}
		var countl=0;
		var countr=0;
		var count=0;
		var timebeat=this.TB[len-1]+1;
		for (var i = 0; i < this.LL.length; i++) {
			if(this.LL[i]>0){
				count=0;
				countl++;
				for (var j=i+1; j<this.LL.length*2; j++) {
					count++;
					if (this.LL[j%timebeat]>0){
						break
					}
				}
				this.LL[i]=count*this.resolution;
			}	
			if(this.RL[i]>0){
				count=0;
				countr++;
				for (var j=i+1; j<this.RL.length*2; j++) {
					count++;
					if (this.RL[j%timebeat]>0){
						break
					}
				}
				this.RL[i]=count*this.resolution;
			}	
		}
		
		var lenl=this.LL.length;
		if (this.normal==0){
			for (var i = 0; i < lenl; i++) {
				if(this.LL[i]>this.resolution*2){
					this.LL[(i+2)%lenl]=this.LL[i]-this.resolution*2;
					this.LL[i]=this.resolution*2;
				}
				if(this.RL[i]>this.resolution*2){
					this.RL[(i+2)%lenl]=this.RL[i]-this.resolution*2;
					this.RL[i]=this.resolution*2;
				}
			
			}
		}
		
				
		
		//Catch and throw posiotions
		var styleL="new Array(";
		var stylel="";
		var styleR="new Array(";
		var styler="";
		var i=0;
		var k=0;
		while (s!=59) {// ;
			i++;
			var s = parseInt(this.style.charCodeAt(i));

			if(s!=41 && s!=59) { //  ) & ;
				stylel=stylel+""+this.style.charAt(i);	
				if(s==44) {
					k++;
				}
			}else{
				i++;
				if(s==41){
					var n=new Array();
					sl=stylel;
					var N=0;
					for (var j = 0; j < k; j++) {
						n[j]=sl.indexOf(",")+N;
						sl=stylel.substring(n[j]+1,stylel.length-1);
						N=n[j]+1;
						//alert(k+'   '+n+'   '+N+'   '+sl+'   '+stylel);

					}
					if (k==1){
					var sub1=stylel.substring(0,n[0]);
					var sub2=stylel.substring(n[0]+1,stylel.length);
					 styleL = styleL.concat(sub1,",-50,200,",sub2,",-50,200"); 
					}
					if (k==3){
					var sub1=stylel.substring(0,n[1]);
					var sub2=stylel.substring(n[1]+1,stylel.length);
					 styleL = styleL.concat(sub1,",200,",sub2,",200"); 
					}
					if (k==5){
						styleL = styleL.concat(stylel);
					}
					//alert(sub1+'        '+sub2+'              '+styleL);
						
					k=0;
					stylel="";		
				}
				
				if (parseInt(this.style.charCodeAt(i))==59){
					break;
				}else{

					styleL=styleL+",";

				}
			}
		}
		styleL=styleL+")";		//alert(styleL);
		var k=0;
		for (var j = i+2; j < this.style.length; j++) {
			var s = parseInt(this.style.charCodeAt(j));
							

			if(s!=41 && s!=59) {
				styler=styler+""+this.style.charAt(j);
				if(s==44) {
					k++;
				}
			}else{
				if(s==41){
					var n=new Array();
					sr=styler;
					var N=0;
					for (var r = 0; r < k; r++) {
						n[r]=sr.indexOf(",")+N;
						sr=styler.substring(n[r]+1,styler.length-1);
						N=n[r]+1;
						//alert(k+'   '+n+'   '+N+'   '+sl+'   '+stylel);

					}
					if (k==1){
					var sub1=styler.substring(0,n[0]);
					var sub2=styler.substring(n[0]+1,styler.length);
					 styleR = styleR.concat(sub1,",-50,200,",sub2,",-50,200"); 
					}
					if (k==3){
					var sub1=styler.substring(0,n[1]);
					var sub2=styler.substring(n[1]+1,styler.length);
					 styleR = styleR.concat(sub1,",200,",sub2,",200"); 
					}
					if (k==5){
						styleR = styleR.concat(styler);
					}
					//alert(sub1+'        '+sub2+'              '+styleL);
						
					k=0;
					styler="";	
					if(j==this.style.length-1){break}
				}
				styleR=styleR+",";
				j++;
			}
		}
		styleR=styleR+")"; //alert(styleR);
		this.styleleft = eval(styleL);
		this.styleright = eval(styleR);

//alert(this.SSL + ' : ' + this.SSR + ' : ' + this.SSLX + ' : ' + this.SSRX + ' : ' + this.TB)

		//alert(this.normal+'   '+this.RL+'   '+this.LL)			
		//lcm styleleft/6,countl
		if (countl==0) {countl=1};
		if (countr==0) {countr=1};

		var lcml=getLCM(countl,this.styleleft.length/6);
		lcml=lcml/countl;
		
		//lcm styleright/6,countt
		var lcmr=getLCM(countr,this.styleright.length/6);
		lcmr=lcmr/countr;
		//lcm lcml,lcmr
		var lcmlr=getLCM(lcml,lcmr);
				//alert(lcml + ' : ' + lcmr + ' : ' + lcmlr)


		//update SSL SSR ...
		for (var j = 1; j < lcmlr; j++) {
			tb=this.TB[this.TB.length-1]+1;
			for (var i = 0; i < len; i++) {
				this.SSL[len*j+i]=this.SSL[i];
				this.SSR[len*j+i]=this.SSR[i];
				this.SSLX[len*j+i]=this.SSLX[i];
				this.SSRX[len*j+i]=this.SSRX[i];
				this.TB[len*j+i]=this.TB[i]+tb;
			}
		}
					//alert(this.SSL);

		//update LL LR ...
		var lenll=this.LL.length;
		for (var j = 1; j < lcmlr; j++) {
			for (var i = 0; i < lenll; i++) {
				this.LL[lenll*j+i]=this.LL[i];
				this.RL[lenll*j+i]=this.RL[i];

			}
					
	
		}
								//alert(this.LL + '   '+lenll);

		//create T1 C1 C2A
		var kl=-1;
		var kr=-1;
		var lenl=this.styleleft.length/6;
		var lenr=this.styleright.length/6;
		
		if (this.normal==1 && this.number==this.maxThrow && this.maxThrow%2==1) {
			for (var i = 0; i < this.styleleft.length; i+=3) {
				this.styleleft[i]=this.styleleft[i]+30*(this.number/(this.tsec*3));
				this.styleright[i]=this.styleright[i]+30*(this.number/(this.tsec*3));
			}
		}
		if (this.normal==1 && this.number==this.maxThrow && this.maxThrow%2==0) {
											

			for (var i = 3; i < this.styleleft.length; i+=6) {
					this.styleleft[i]=this.styleleft[i]-70*(this.number/(this.tsec*3));
					this.styleright[i]=this.styleright[i]-70*(this.number/(this.tsec*3));
			}
		}

		for (var i = 0; i < this.LL.length; i++) {
			if (this.LL[i]>0) {
				kl++;
				this.LC1x[i]=this.styleleft[(kl%lenl)*6];
				this.LC1y[i]=this.styleleft[(kl%lenl)*6+1];
				this.LC1z[i]=this.styleleft[(kl%lenl)*6+2];
				this.LT1x[i]=this.styleleft[(kl%lenl)*6+3];
				this.LT1y[i]=this.styleleft[(kl%lenl)*6+4];
				this.LT1z[i]=this.styleleft[(kl%lenl)*6+5];
				this.LC2Ax[i]=this.styleleft[((kl+1)%lenl)*6];
				this.LC2Ay[i]=this.styleleft[((kl+1)%lenl)*6+1];
				this.LC2Az[i]=this.styleleft[((kl+1)%lenl)*6+2];
			}else{
				this.LC1x[i]=0;
				this.LC1y[i]=0;
				this.LC1z[i]=0;
				this.LT1x[i]=0;
				this.LT1y[i]=0;
				this.LT1z[i]=0;
				this.LC2Ax[i]=0;
				this.LC2Ay[i]= 0;
				this.LC2Az[i]= 0;
			}
			if (this.RL[i]>0) {
				kr++;
				this.RC1x[i]=this.styleright[(kr%lenr)*6];
				this.RC1y[i]=this.styleright[(kr%lenr)*6+1];
				this.RC1z[i]=this.styleright[(kr%lenr)*6+2];
				this.RT1x[i]=this.styleright[(kr%lenr)*6+3];
				this.RT1y[i]=this.styleright[(kr%lenr)*6+4];
				this.RT1z[i]=this.styleright[(kr%lenr)*6+5];
				this.RC2Ax[i]=this.styleright[((kr+1)%lenr)*6];
				this.RC2Ay[i]=this.styleright[((kr+1)%lenr)*6+1];
				this.RC2Az[i]=this.styleright[((kr+1)%lenr)*6+2];
			}else{
				this.RC1x[i]=0;
				this.RC1y[i]=0;
				this.RC1z[i]=0;
				this.RT1x[i]=0;
				this.RT1y[i]=0;
				this.RT1z[i]=0;
				this.RC2Ax[i]=0;
				this.RC2Ay[i]= 0;
				this.RC2Az[i]= 0;
			}
		}
		
		
		
		//alert(this.SSL+'   '+this.LC2Bx);	
		var rep=291;
		var ran=0;
		var dt=0.9;
		var dt2=1000*(this.number/(this.tsec*3));
		len =this.SSL.length;
		//update SSL SSR ...
		for (var j = 1; j < rep; j++) {
			if (this.normal==1 && this.number==this.maxThrow && this.maxThrow%2==1) {

				dt=1-0.5*Math.abs((rep/2-j)/(rep/2));
			}
			else if (this.normal==1 && this.number==this.maxThrow && this.maxThrow%2==0) {

				dt=0.5*Math.abs((rep/2-j)/(rep/2))-0.3;
			}else{
				dt=0.5;
			}
			tb=this.TB[this.TB.length-1]+1;
			for (var i = 0; i < len; i++) {
				this.SSL[len*j+i]=this.SSL[i];
				this.SSR[len*j+i]=this.SSR[i];
				this.SSLX[len*j+i]=this.SSLX[i];
				this.SSRX[len*j+i]=this.SSRX[i];
				this.TB[len*j+i]=this.TB[i]+tb;
				
				/*ran=Math.random();
				this.LC2Bx[len*j+i]=this.LC2Bx[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.LC2By[len*j+i]= this.LC2By[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.LC2Bz[len*j+i]= this.LC2Bz[i]+(dt-ran)*(1-this.skill)*dt2;
				
				ran=Math.random();
				this.RC2Bx[len*j+i]=this.RC2Bx[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.RC2By[len*j+i]= this.RC2By[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.RC2Bz[len*j+i]= this.RC2Bz[i]+(dt-ran)*(1-this.skill)*dt2;*/
				

			}
		}
						//alert(this.SSL+'   '+this.LC2Bx);			

		//update LL LR ...
		var lenll=this.LL.length;
		for (var j = 1; j < rep; j++) {
			for (var i = 0; i < lenll; i++) {
				this.LL[lenll*j+i]=this.LL[i];
				this.RL[lenll*j+i]=this.RL[i];
				
				ran=Math.random();
				this.LC1x[lenll*j+i]=this.LC1x[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.LC1y[lenll*j+i]=this.LC1y[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LC1z[lenll*j+i]=this.LC1z[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LT1x[lenll*j+i]=this.LT1x[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LT1y[lenll*j+i]=this.LT1y[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LT1z[lenll*j+i]=this.LT1z[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LC2Ax[lenll*j+i]=this.LC2Ax[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.LC2Ay[lenll*j+i]= this.LC2Ay[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.LC2Az[lenll*j+i]= this.LC2Az[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				
				ran=Math.random();
				this.RC1x[lenll*j+i]=this.RC1x[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.RC1y[lenll*j+i]=this.RC1y[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RC1z[lenll*j+i]=this.RC1z[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RT1x[lenll*j+i]=this.RT1x[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RT1y[lenll*j+i]=this.RT1y[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RT1z[lenll*j+i]=this.RT1z[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RC2Ax[lenll*j+i]=this.RC2Ax[i]+(dt-ran)*(1-this.skill)*dt2;
				ran=Math.random();
				this.RC2Ay[lenll*j+i]= this.RC2Ay[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
				ran=Math.random();
				this.RC2Az[lenll*j+i]=this.RC2Az[i]+(dt-ran)*(1-this.skill)*dt2*0.5;
			}
					
	
		}
		
		
		
		
		//create T1 C1 C2B
		var landh;
		var pos;
		for (var i = 0; i < this.SSL.length; i++) {
			if (this.SSL[i]>0) {
				landh=Math.pow(-1,this.SSL[i]+1)*this.SSLX[i]; //land hand
				pos=(this.TB[i]+this.SSL[i])%this.LL.length;
				if (landh==-1) { //left hand
					this.LC2Bx[i]=this.LC1x[pos];
					this.LC2By[i]=this.LC1y[pos];
					this.LC2Bz[i]=this.LC1z[pos];
				}else{
					this.LC2Bx[i]=this.RC1x[pos];
					this.LC2By[i]=this.RC1y[pos];
					this.LC2Bz[i]=this.RC1z[pos];
				}

			}else{
				this.LC2Bx[i]=0;
				this.LC2By[i]= 0;
				this.LC2Bz[i]= 0;
			}
			if (this.SSR[i]>0) {
				landh=Math.pow(-1,this.SSR[i])*this.SSRX[i]; //land hand
				pos=(this.TB[i]+this.SSR[i])%this.RL.length;
				if (landh==-1) { //left handi
					this.RC2Bx[i]=this.LC1x[pos];
					this.RC2By[i]=this.LC1y[pos];
					this.RC2Bz[i]=this.LC1z[pos];
				}else{
					this.RC2Bx[i]=this.RC1x[pos];
					this.RC2By[i]=this.RC1y[pos];
					this.RC2Bz[i]=this.RC1z[pos];
				}
			}else{
				this.RC2Bx[i]=0;
				this.RC2By[i]= 0;
				this.RC2Bz[i]= 0;
			}
		}
		
		
		
	//alert(this.LL + '   ' + this.LC1x+ '   ' + this.LC1y+ '   ' + this.LC1z+'   ' + this.LT1x+ '   ' + this.LT1y + '   ' + this.LC2Ax+ '   ' + this.LC2Ay+ '   ' + this.LC2Bx+ '   ' + this.LC2By)	
	//alert(this.RL + '   ' + this.RC1x+ '   ' + this.RC1y+ '   ' + this.RC1z+'   ' + this.RT1x+ '   ' + this.RT1y + '   ' + this.RC2Ax+ '   ' + this.RC2Ay+ '   ' + this.RC2Bx+ '   ' + this.RC2By)	

		//alert(this.SSR +' : ' + this.RL +' : ' +this.LL)
		//alert(this.maxThrow +' : ' + this.number +' : ' +this.SSL + ' : ' + this.SSR + ' : ' + this.SSLX + ' : ' + this.SSRX + ' : ' + this.TB)

		/*//[43]23
		this.SSL=[4,3,0,3,0,0,2,0];
		this.SSR=[0,0,2,0,4,3,0,3];
		this.SSLX=[1,1,1,1,1,1,1,1];
		this.SSRX=[1,1,1,1,1,1,1,1];
		this.TB=[0,0,1,2,3,3,4,5];
		this.maxThrow=4;
		this.number=4;*/
		/*//(6X,4)*
		this.SSL=[6,0,4,0];
		this.SSR=[4,0,6,0];
		this.SSLX=[-1,1,1,1];
		this.SSRX=[1,1,-1,1];
		this.TB=[0,1,2,3];
		this.maxThrow=6;
		this.number=5;*/
		/*//([4x4],2)*
		this.SSL=[4,4,0,2,0,0];
		this.SSR=[2,0,0,4,4,0];
		this.SSLX=[-1,1,1,1,1,1];
		this.SSRX=[1,1,1,-1,1,1];
		this.TB=[0,0,1,2,2,3];
		this.maxThrow=4;
		this.number=5;*/
		/*//(3x,2x)21x
		this.SSL=[3,0,2,0];
		this.SSR=[2,0,0,1];
		this.SSLX=[1,1,1,1];
		this.SSRX=[-1,1,1,-1];
		this.TB=[0,1,2,3];
		this.maxThrow=3;
		this.number=2;*/
		/*//3x4x(3,0)!(2x,0)(4,[2x3x])
		this.SSL=[3,0,3,2,0,4,0,0];
		this.SSR=[0,4,0,0,0,2,3,0];
		this.SSLX=[-1,1,1,-1,1,1,1,1];
		this.SSRX=[1,-1,1,1,1,-1,-1,1];
		this.TB=[0,1,2,3,4,5,5,6];
		this.maxThrow=4;
		this.number=3;*/
		/*//3x4x(3,0)!(2,0)([2x4x],3)*
		this.SSL=[3,0,3,2,0,2,4,0,0,4,0,0,0,3,0,0];
		this.SSR=[0,4,0,0,0,3,0,0,3,0,3,2,0,2,4,0];
		this.SSLX=[-1,1,1,1,1,-1,-1,1,1,-1,1,1,1,1,1,1];
		this.SSRX=[1,-1,1,1,1,1,1,1,-1,1,1,1,1,-1,-1,1];
		this.TB=[0,1,2,3,4,5,5,6,7,8,9,10,11,12,12,13];
		this.maxThrow=4;
		this.number=3;*/
		//number of balls
		//this.number = m / this.SSL.length;

		return true;
	}
	
	function getGCD(x,y) {
		var w;
		while (y != 0) {
			w = x % y;
			x = y;
			y = w;
		}
		return x;
	}
	function getLCM(x,y) {
		var gcd = getGCD(x,y);
		var lcm = (x * y) / gcd;
		return lcm
	}