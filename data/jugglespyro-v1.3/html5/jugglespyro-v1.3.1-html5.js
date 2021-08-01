(function (cjs, an) {

var p; // shortcut to reference prototypes
var lib={};var ss={};var img={};
lib.ssMetadata = [];


(lib.AnMovieClip = function(){
	this.actionFrames = [];
	this.gotoAndPlay = function(positionOrLabel){
		cjs.MovieClip.prototype.gotoAndPlay.call(this,positionOrLabel);
	}
	this.play = function(){
		cjs.MovieClip.prototype.play.call(this);
	}
	this.gotoAndStop = function(positionOrLabel){
		cjs.MovieClip.prototype.gotoAndStop.call(this,positionOrLabel);
	}
	this.stop = function(){
		cjs.MovieClip.prototype.stop.call(this);
	}
}).prototype = p = new cjs.MovieClip();
// symbols:



(lib._1hand = function() {
	this.initialize(img._1hand);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib._1hand_grey = function() {
	this.initialize(img._1hand_grey);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib._2handssync = function() {
	this.initialize(img._2handssync);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib._2handssync_grey = function() {
	this.initialize(img._2handssync_grey);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.clean = function() {
	this.initialize(img.clean);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.ColorWheel = function() {
	this.initialize(img.ColorWheel);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,854,854);


(lib.creditsimg = function() {
	this.initialize(img.creditsimg);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,507,580);


(lib.help = function() {
	this.initialize(img.help);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.info = function() {
	this.initialize(img.info);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.pause = function() {
	this.initialize(img.pause);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.photo = function() {
	this.initialize(img.photo);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.play = function() {
	this.initialize(img.play);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.reset = function() {
	this.initialize(img.reset);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.save = function() {
	this.initialize(img.save);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.start_record = function() {
	this.initialize(img.start_record);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.stop = function() {
	this.initialize(img.stop);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.stop_record = function() {
	this.initialize(img.stop_record);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.target = function() {
	this.initialize(img.target);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.videorandom = function() {
	this.initialize(img.videorandom);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);


(lib.videoXML = function() {
	this.initialize(img.videoXML);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,34,32);


(lib.videoXMLfile = function() {
	this.initialize(img.videoXMLfile);
}).prototype = p = new cjs.Bitmap();
p.nominalBounds = new cjs.Rectangle(0,0,32,32);// helper functions:

function mc_symbol_clone() {
	var clone = this._cloneProps(new this.constructor(this.mode, this.startPosition, this.loop, this.reversed));
	clone.gotoAndStop(this.currentFrame);
	clone.paused = this.paused;
	clone.framerate = this.framerate;
	return clone;
}

function getMCSymbolPrototype(symbol, nominalBounds, frameBounds) {
	var prototype = cjs.extend(symbol, cjs.MovieClip);
	prototype.clone = mc_symbol_clone;
	prototype.nominalBounds = nominalBounds;
	prototype.frameBounds = frameBounds;
	return prototype;
	}


(lib.an_TextInput = function(options) {
	this.initialize();
	this._element = new $.an.TextInput(options);
	this._el = this._element.create();
}).prototype = p = new cjs.MovieClip();
p.nominalBounds = new cjs.Rectangle(0,0,100,22);

p._tick = _tick;
p._handleDrawEnd = _handleDrawEnd;
p._updateVisibility = _updateVisibility;
p.draw = _componentDraw;



(lib.SliderBar = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	// Calque_1
	this.shape = new cjs.Shape();
	this.shape.graphics.f("#CCCCCC").s().p("Aj5APIAAgdIHzAAIAAAdg");
	this.shape.setTransform(25,1.5);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.SliderBar, new cjs.Rectangle(0,0,50,3), null);


(lib.credits = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	// Calque_1
	this.instance = new lib.creditsimg();

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.credits, new cjs.Rectangle(0,0,507,580), null);


(lib.SliderThumb_upSkin = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	// skin
	this.shape = new cjs.Shape();
	this.shape.graphics.lf(["rgba(204,204,204,0.4)","rgba(255,255,255,0.6)"],[0,1],0,5.5,0,-5.5).s().p("AgiA3IgUgUIAshZIAVAAIAsBZIgUAUg");
	this.shape.setTransform(0,6.5);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.lf(["#5B5D5E","#B7BABC"],[0,1],0,6.5,0,-6.5).s().p("AgsBBIgUgeIA2hjIAVAAIA2BjIgUAegAg2AjIAUAUIBFAAIAUgUIgshZIgVAAg");
	this.shape_1.setTransform(0,6.5);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.shape_1},{t:this.shape}]}).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.SliderThumb_upSkin, new cjs.Rectangle(-6.5,0,13,13), null);


(lib.an_ComboBox = function(options) {
	this.initialize();
	this._element = new $.an.ComboBox(options);
	this._el = this._element.create();
}).prototype = p = new cjs.MovieClip();
p.nominalBounds = new cjs.Rectangle(0,0,100,22);

p._tick = _tick;
p._handleDrawEnd = _handleDrawEnd;
p._updateVisibility = _updateVisibility;
p.draw = _componentDraw;



(lib.an_Checkbox = function(options) {
	this.initialize();
	this._element = new $.an.Checkbox(options);
	this._el = this._element.create();
}).prototype = p = new cjs.MovieClip();
p.nominalBounds = new cjs.Rectangle(0,0,100,22);

p._tick = _tick;
p._handleDrawEnd = _handleDrawEnd;
p._updateVisibility = _updateVisibility;
p.draw = _componentDraw;



(lib.bt_target = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Center and Join Axis
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_targetEvent = new createjs.Event("bt_target", true);		
			that.dispatchEvent(bt_targetEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.target, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_target, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_stop_record = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Stop Record
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_stopRecordEvent = new createjs.Event("bt_stop_record", true);		
			that.dispatchEvent(bt_stopRecordEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.instance = new lib.stop_record();

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_stop_record, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_stop = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Stop
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {		
			var bt_stopEvent = new createjs.Event("bt_stop", true);		
			that.dispatchEvent(bt_stopEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.stop, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_stop, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_start_record = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Start Record
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_startRecordEvent = new createjs.Event("bt_start_record", true);		
			that.dispatchEvent(bt_startRecordEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.instance = new lib.start_record();

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_start_record, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_start = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Start
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {	
			var bt_startEvent = new createjs.Event("bt_start", true);		
			that.dispatchEvent(bt_startEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.play, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_start, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_runXML = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Run XML
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_runXMLEvent = new createjs.Event("bt_runXML", true);		
			that.dispatchEvent(bt_runXMLEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.instance = new lib.videoXML();

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_runXML, new cjs.Rectangle(0,0,34,32), null);


(lib.bt_reset = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Reset
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_resetEvent = new createjs.Event("bt_reset", true);		
			that.dispatchEvent(bt_resetEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.reset, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_reset, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_random = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Random Anim
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_randomEvent = new createjs.Event("bt_random_anim", true);		
			that.dispatchEvent(bt_randomEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.videorandom, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_random, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_pause = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Pause
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_pauseEvent = new createjs.Event("bt_pause", true);		
			that.dispatchEvent(bt_pauseEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.pause, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_pause, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_loadXMLFile = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Load XML File 
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_loadXMLFileEvent = new createjs.Event("bt_loadXMLFile", true);		
			that.dispatchEvent(bt_loadXMLFileEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.instance = new lib.videoXMLfile();

	this.timeline.addTween(cjs.Tween.get(this.instance).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_loadXMLFile, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_help_show = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Show Help
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {		
			var bt_helpShowEvent = new createjs.Event("bt_help_show", true);		
			that.dispatchEvent(bt_helpShowEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.help, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_help_show, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_go_two = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Go Two 
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_go_twoEvent = new createjs.Event("bt_go_two", true);		
			that.dispatchEvent(bt_go_twoEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img._2handssync, null, new cjs.Matrix2D(1,0,0,0.984,-16,-15.7)).s().p("AifCeIAAk6IB0AAIAAABIABAAQAAABAAAAQAAABAAAAQAAABABABQAAAAABABIABADIAHADIAEABIACAAQABAAAAAAQABAAABAAQAAgBABAAQAAAAABgBIADgBIACgDIABgBIABgCIADAAIACgBIAFAAIABAAIABAAIAEAAIABAAIAAAAIAFAAIABAAIABAAIACABIAFAAIABgBIABABIADAAIABABIABAAIABACIADACQAEACAEgBIAGAAIABAAIABABIACABIAEABIADABIADAAIADAAIAEgDIAAAAIABACIACABIAFACIAFABQAEACAFgBIACgBIACgBIAEgDIADgGIAAgDIAAgEIBAAAIAAE6g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_go_two, new cjs.Rectangle(0,0.3,32,31.5), null);


(lib.bt_go_one = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Go One
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_go_oneEvent = new createjs.Event("bt_go_one", true);		
			that.dispatchEvent(bt_go_oneEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img._1hand, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_go_one, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_exportXML = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// export XML
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_exportXMLEvent = new createjs.Event("bt_exportXML", true);		
			that.dispatchEvent(bt_exportXMLEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.save, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_exportXML, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_exportImg = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Export Image in PNG
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_exportImgEvent = new createjs.Event("bt_exportImg", true);		
			that.dispatchEvent(bt_exportImgEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.photo, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_exportImg, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_credits_show = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Credits
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_credits_showEvent = new createjs.Event("bt_credits_show", true);		
			that.dispatchEvent(bt_credits_showEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.info, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_credits_show, new cjs.Rectangle(0,0,32,32), null);


(lib.bt_clean = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Clean
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var bt_cleanEvent = new createjs.Event("bt_clean", true);		
			that.dispatchEvent(bt_cleanEvent);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Scripts
	this.shape = new cjs.Shape();
	this.shape.graphics.bf(img.clean, null, new cjs.Matrix2D(1,0,0,1,-16,-16)).s().p("AifCgIAAk/IE/AAIAAE/g");
	this.shape.setTransform(16,16);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.bt_clean, new cjs.Rectangle(0,0,32,32), null);


(lib.ColorSelectorShow = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Color Selector Show
		//==================================================
		var that = this;
		
		this.on('click', function(evt) {
			var colorSelectShowEvent = new createjs.Event("colorSelectShow", true);			
			colorSelectShowEvent.initiator=evt.currentTarget.name;
			that.dispatchEvent(colorSelectShowEvent);		
		});
		
		
		this.setColor = function(color)
		{
			that.shape_1.graphics._fill.style = color;
		}
		
		
		this.getColor = function()
		{
			return that.shape_1.graphics._fill.style;
		}
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Layer1
	this.shape = new cjs.Shape();
	this.shape.graphics.f().s("rgba(153,153,153,0.698)").ss(2,1,1,3,true).p("AipipIFTAAIAAFTIlTAAg");
	this.shape.setTransform(0.5752,-0.1455,0.4414,0.4413);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.f("#00FF33").s().p("AipCqIAAlTIFTAAIAAFTg");
	this.shape_1.setTransform(0.5752,-0.1455,0.4414,0.4413);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.shape_1},{t:this.shape}]}).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.ColorSelectorShow, new cjs.Rectangle(-7.9,-8.6,17,17), null);


(lib.ColorSelector_Preview = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	// Layer 1
	this.shape = new cjs.Shape();
	this.shape.graphics.f("#F2F2F2").s().p("AiiCiQhDhDAAhfQAAheBDhEQBEhDBeAAQBfAABDBDQBEBEAABeQAABfhEBDQhDBEhfAAQheAAhEhEg");
	this.shape.setTransform(23,23);

	this.timeline.addTween(cjs.Tween.get(this.shape).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.ColorSelector_Preview, new cjs.Rectangle(0,0,46,46), null);


(lib.Slider = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Slider
		//==================================================
		var that = this;
		var displayWidth = stage.canvas.width/stage.scaleX;
		var displayHeight = stage.canvas.height/stage.scaleY;
		var animTimerValueMax = 100;
		var enabling = true;
		
		
		this.SliderThumb.on("pressmove", function (evt) {
			if (that.enabling == false) {
				return;
			}
			
			that.SliderThumb.x = that.clamp(evt.stageX / stage.scaleX - that.x +that.SliderBar.x, 0, that.nominalBounds.width);
			var bt_sliderEvent = new createjs.Event('bt_slider', true);
			bt_sliderEvent.initiator = that.name;
			if (bt_sliderEvent.initiator == 'bt_right_axisInitdx') {
				that.val = that.SliderThumb.x * displayWidth / that.nominalBounds.width;		
			} else if (bt_sliderEvent.initiator == 'bt_right_axisInitdy') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width;
			} else if (bt_sliderEvent.initiator == 'bt_right_armLength') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width / 4;
			} else if (bt_sliderEvent.initiator == 'bt_right_propLength') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width / 4;
			} else if (bt_sliderEvent.initiator == 'bt_right_clockSpeed') {
				that.val = that.SliderThumb.x * 10 / that.nominalBounds.width + 0.5;
			} else if (bt_sliderEvent.initiator == 'bt_left_axisInitdx') {
				that.val = that.SliderThumb.x * displayWidth / that.nominalBounds.width;
			} else if (bt_sliderEvent.initiator == 'bt_left_axisInitdy') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width;
			} else if (bt_sliderEvent.initiator == 'bt_left_armLength') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width / 4;
			} else if (bt_sliderEvent.initiator == 'bt_left_propLength') {
				that.val = that.SliderThumb.x * displayHeight / that.nominalBounds.width / 4;
			} else if (bt_sliderEvent.initiator == 'bt_left_clockSpeed') {
				that.val = that.SliderThumb.x * 10 / that.nominalBounds.width + 0.5;
			} else if (bt_sliderEvent.initiator == 'bt_speed') {
				that.val = that.SliderThumb.x * animTimerValueMax / that.nominalBounds.width;
			} else if (bt_sliderEvent.initiator == 'bt_scale') {
				that.val = that.SliderThumb.x * 2 / that.nominalBounds.width;
			} else {
				console.log('Unknown Slider Instance :', bt_sliderEvent.initiator);
				that.val = that.SliderThumb.x;
			}
		
			that.dispatchEvent(bt_sliderEvent);
		});
		
		
		this.clamp = function (value, min, max) {
			if (value < min)
				return min;
			else if (value > max)
				return max;
			else
				return value;
		}
		
		
		this.setSlider = function (value) {
			that.val = value;
			if (that.name == 'bt_right_axisInitdx') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / displayWidth, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_right_axisInitdy') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_right_armLength') {
				that.SliderThumb.x = that.clamp(value * 4 * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_right_propLength') {
				that.SliderThumb.x = that.clamp(value * 4 * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_right_clockSpeed') {
				that.SliderThumb.x = that.clamp((value - 0.5) * that.nominalBounds.width / 10, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_left_axisInitdx') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / displayWidth, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_left_axisInitdy') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_left_armLength') {
				that.SliderThumb.x = that.clamp(value * 4 * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_left_propLength') {
				that.SliderThumb.x = that.clamp(value * 4 * that.nominalBounds.width / displayHeight, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_left_clockSpeed') {
				that.SliderThumb.x = that.clamp((value - 0.5) * that.nominalBounds.width / 10, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_speed') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / animTimerValueMax, 0, that.nominalBounds.width);
			} else if (that.name == 'bt_scale') {
				that.SliderThumb.x = that.clamp(value * that.nominalBounds.width / 2, 0, that.nominalBounds.width);
			} else {
				console.log('Unknown Slider Instance :', that.name);
				that.SliderThumb.x = that.clamp(value, 0, that.nominalBounds.width);
			}
		}
		
		
		this.getValue = function (value) {
			return that.val;
		}
		
		
		this.enable = function (bool) {	
			that.enabling = bool;
		}
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Layer1
	this.SliderThumb = new lib.SliderThumb_upSkin();
	this.SliderThumb.name = "SliderThumb";
	this.SliderThumb.setTransform(0.05,0.8,0.6154,0.6154,0,0,0,0.1,6.6);

	this.SliderBar = new lib.SliderBar();
	this.SliderBar.name = "SliderBar";
	this.SliderBar.setTransform(25,-2.2,1,1,0,0,0,25,1.5);

	this.shape = new cjs.Shape();
	this.shape.graphics.f().s("#666666").ss(1,1,1).p("AD6gOIAAAdInzAAIAAgdg");
	this.shape.setTransform(25,-2.2);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.shape},{t:this.SliderBar},{t:this.SliderThumb}]}).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.Slider, new cjs.Rectangle(-4,-4.7,55,9.5), null);


(lib.ColorSelector = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.isSingleFrame = false;
	// timeline functions:
	this.frame_0 = function() {
		if(this.isSingleFrame) {
			return;
		}
		if(this.totalFrames == 1) {
			this.isSingleFrame = true;
		}
		//==================================================
		// Color Selector
		//==================================================
		var currentRGBA = null,
			that = this;
		
		
		this.on('click', function(evt) {
			var colorSelectEvent = new createjs.Event("colorSelect", true);
			colorSelectEvent.rgba = currentRGBA;	
			that.dispatchEvent(colorSelectEvent);	
		});
		
		function onStageMouseMove(evt) {	
			var ctx = stage.canvas.getContext('2d');	
			var data = ctx.getImageData(evt.stageX, evt.stageY, 1, 1).data;	
			currentRGBA = 'rgba(' + data[0] + ',' + data[1] + ',' + data[2] + ',' + data[3] + ')';
			// Set preview color
			that.ColorSelector_Preview.shape.graphics._fill.style = currentRGBA;		
		}
		
		this.on('rollover', function(evt) {
			stage.addEventListener('stagemousemove', onStageMouseMove);	
		});
		
		this.on('rollout', function(evt) {
			stage.removeEventListener('stagemousemove', onStageMouseMove);	
		});
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1));

	// Layer 1
	this.ColorSelector_Preview = new lib.ColorSelector_Preview();
	this.ColorSelector_Preview.name = "ColorSelector_Preview";
	this.ColorSelector_Preview.setTransform(167.95,195.85,1.696,1.6962,0,0,0,22.6,22.6);

	this.instance = new lib.ColorWheel();
	this.instance.setTransform(-49,-22,0.5105,0.5105);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.instance},{t:this.ColorSelector_Preview}]}).wait(1));

	this._renderFirstFrame();

}).prototype = getMCSymbolPrototype(lib.ColorSelector, new cjs.Rectangle(-49,-22,436,436), null);


// stage content:
(lib.jugglespyrov131html5 = function(mode,startPosition,loop,reversed) {
if (loop == null) { loop = true; }
if (reversed == null) { reversed = false; }
	var props = new Object();
	props.mode = mode;
	props.startPosition = startPosition;
	props.labels = {load:0,two:1,one:11};
	props.loop = loop;
	props.reversed = reversed;
	cjs.MovieClip.apply(this,[props]);

	this.actionFrames = [0,1,11];
	// timeline functions:
	this.frame_0 = function() {
		//##############################################################################
		//## juggleSpyro                                                              ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//## Copyright (C) 2014-2020  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
		//##                                                                          ##
		//##                                                                          ##
		//## This program is free software; you can redistribute it and/or modify it  ##
		//## under the terms of the GNU General Public License version 3 as           ##
		//## published by the Free Software Foundation; version 3.                    ##
		//##                                                                          ##
		//## This program is distributed in the hope that it will be useful, but      ##
		//## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
		//## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
		//## General Public License for more details.                                 ##
		//##                                                                          ##
		//##############################################################################
		
		_root = this;
		
		_root.JSpyroGoPage = "two";
		_root.JSpyroColorBackground = 'rgba(219,232,118,255)';
		_root.JSpyroScaling = 1;
		_root.JSpyroSpeed = 80;
		_root.JSpyroGIFQuality = 10;
		_root.JSpyroGIFWorkers = 2;
		_root.JSpyroGIFWidth = 400;
		_root.JSpyroGIFHeight = 300;
		_root.JSpyroGIFFrameDelay = 60;
		_root.JSpyroGIFGrain = 4;
		_root.JSpyroHelpURL = './help/help.html';
		_root.JSpyroRightObjHandleSize = 4;
		_root.JSpyroRightColorObjHandle = 'rgba(0,0,0,1)';
		_root.JSpyroRightPropPathSize = 4;
		_root.JSpyroRightHandPathSize = 4;
		_root.JSpyroRightPoiStringSize = 2;
		_root.JSpyroRightPoiRadius = 8;
		_root.JSpyroRightObjStrokeSize = 3;
		_root.JSpyroLeftObjHandleSize = 4;
		_root.JSpyroLeftColorObjHandle = 'rgba(0,0,0,1)';
		_root.JSpyroLeftPropPathSize = 4;
		_root.JSpyroLeftHandPathSize = 4;
		_root.JSpyroLeftPoiStringSize = 2;
		_root.JSpyroLeftPoiRadius = 8;
		_root.JSpyroLeftObjStrokeSize = 3;
		_root.JSpyroClockSpeedRatio = 1;
		_root.JSpyroSetClockSpeedRatio = true;
		_root.JSpyroCleaningMode = true;
		_root.JSpyroRandomMode = false;
		_root.JSpyroXMLSceneMode=true;
		_root.JSpyroNbColorTransform=1;
		_root.JSpyroLoadXMLFileInput='<?xml version="1.0" encoding="UTF-8"?>\
		<animation name="Demo">\
		<scenario name="demo1">\
		<scene name="scene1">\
		<right axisDx="390" axisDy="300" propChoice="4" armWay="out" ratio="0" nbloops="1" armAngle="0" propAngle="0" clockSpeed="4" armLength="100" propLength="50" colorHandPath="rgba(0,255,0,1)" colorPropPath="rgba(255,204,0,1)" colorFilter="rgba(251,247,171,255)" handPathViewMode="0" setColorFilter="true" shadow="false" blurring="false" propPathViewMode="3" showAxis="false" cleaning="true" />\
		<left axisDx="410" axisDy="300" propChoice="4" armWay="in" ratio="0" nbloops="1" armAngle="0" propAngle="0" clockSpeed="4" armLength="100" propLength="50" colorHandPath="rgba(0,255,0,1)" colorPropPath="rgba(255,204,0,1)" colorFilter="rgba(251,247,171,255)" handPathViewMode="0" setColorFilter="true" shadow="false" blurring="false" propPathViewMode="3" showAxis="false" cleaning="true" />\
		<both colorBackground="rgba(219,232,118,255)" speed="100" scale="1" clockSpeedRatio="1.0" setClockSpeedRatio="true"/>\
		</scene>\
		<scene name="scene2">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene3">\
		<right ratio="-2" axisDx="400" nbloops="1"/>\
		<left ratio="0" axisDx="400" nbloops="1"/>\
		</scene>\
		<scene name="scene4">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene5">\
		<right ratio="0" axisDx="360" nbloops="1"/>\
		<left ratio="0" axisDx="440" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene6">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene7">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene8">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene9">\
		<right ratio="0" axisDx="390" propAngle="180"  nbloops="1"/>\
		<left ratio="0" axisDx="410" propAngle="180" armWay="in" nbloops="1"/>\
		</scene>\
		<scene name="scene10">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene11">\
		<right ratio="-2" axisDx="400" nbloops="1"/>\
		<left ratio="0" axisDx="400" nbloops="1"/>\
		</scene>\
		<scene name="scene12">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene13">\
		<right ratio="0" axisDx="390" nbloops="1"/>\
		<left ratio="0" axisDx="410" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene14">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene15">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene16">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene17">\
		<right ratio="0" axisDx="400" propAngle="0"  nbloops="1"/>\
		<left ratio="0" axisDx="400" armWay="in" nbloops="1"/>\
		</scene>\
		<scene name="scene18">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene19">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" propAngle="180" nbloops="1"/>\
		</scene>\
		<scene name="scene20">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene21">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="0" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene22">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene23">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene24">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene25">\
		<right ratio="0" armAngle="180" armWay="in" nbloops="1"/>\
		<left ratio="0" propAngle="0" armWay="in" nbloops="1"/>\
		</scene>\
		<scene name="scene26">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene27">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene28">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene29">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="0" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene30">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene31">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene32">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene33">\
		<right ratio="0" propAngle="180" nbloops="1"/>\
		<left ratio="0" propAngle="180" armWay="in" nbloops="1"/>\
		</scene>\
		<scene name="scene34">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene35">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene36">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene37">\
		<right ratio="0" armWay="in" nbloops="1"/>\
		<left ratio="0" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene38">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene39">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene40">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene41">\
		<right ratio="0" propAngle="0" armWay="in" nbloops="1"/>\
		<left ratio="0"  armWay="in" nbloops="1"/>\
		</scene>\
		<scene name="scene42">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene43">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene44">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		<scene name="scene45">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="0" armWay="out" nbloops="1"/>\
		</scene>\
		<scene name="scene46">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene47">\
		<right ratio="0" nbloops="1"/>\
		<left ratio="-2" nbloops="1"/>\
		</scene>\
		<scene name="scene48">\
		<right ratio="-2" nbloops="1"/>\
		<left ratio="0" nbloops="1"/>\
		</scene>\
		</scenario>\
		<scenario name="demo2">\
		<scene name="scene1">\
		<right axisDx="390" axisDy="300" propChoice="4" armWay="in" ratio="0" clockSpeed="4" nbloops="1" armAngle="-90" propAngle="0" armLength="100" propLength="50" colorHandPath="rgba(0,255,0,1)" colorPropPath="rgba(255,204,0,1)" handPathViewMode="0" propPathViewMode="3" setColorFilter="true" colorFilter="rgba(251,247,171,255)" blurring="false" shadow="false" showAxis="false" cleaning="false" handPathEnd="90"/>\
		<left axisDx="410" axisDy="300" propChoice="4" armWay="out" ratio="0" clockSpeed="4" nbloops="1" armAngle="0" propAngle="0" armLength="100" propLength="50" colorHandPath="rgba(0,255,0,1)" colorPropPath="rgba(255,204,0,1)" handPathViewMode="0" propPathViewMode="3" setColorFilter="true" colorFilter="rgba(251,247,171,255)" blurring="false" shadow="false" showAxis="false" cleaning="false" handPathEnd="90"/>\
		<both scale="1" speed="100" colorBackground="rgba(219,232,118,255)"/>\
		</scene>\
		<scene name="scene2">\
		<right ratio="0" armAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="90" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene3">\
		<right ratio="-2" armAngle="90" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="180" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene4">\
		<right ratio="0" armAngle="180" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene5">\
		<right ratio="0" armAngle="-90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="180" propAngle="0" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene6">\
		<right ratio="-2" armAngle="0" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene7">\
		<right ratio="0" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="180" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene8">\
		<right ratio="-2" armAngle="180" propAngle="0" armWay="in" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="-90" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene9">\
		<right ratio="-2" armAngle="-90" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="0" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene10">\
		<right ratio="0" armAngle="0" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene11">\
		<right ratio="-2" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="180" propAngle="0" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene12">\
		<right ratio="0" armAngle="180" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene13">\
		<right ratio="-2" armAngle="-90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="180" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene14">\
		<right ratio="-2" armAngle="0" propAngle="0" armWay="in" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="-90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene15">\
		<right ratio="-2" armAngle="-90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="0" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene16">\
		<right ratio="0" armAngle="0" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="-90" propAngle="0" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene17">\
		<right ratio="-2" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="0" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene18">\
		<right ratio="0" armAngle="180" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="90" propAngle="0" armWay="out" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene19">\
		<right ratio="0" armAngle="90" propAngle="180" armWay="out" nbloops="1" handPathEnd="90"/>\
		<left ratio="0" armAngle="180" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		<scene name="scene20">\
		<right ratio="-2" armAngle="180" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		<left ratio="-2" armAngle="-90" propAngle="180" armWay="in" nbloops="1" handPathEnd="90"/>\
		</scene>\
		</scenario>\
		</animation>';
		
		
		//// Load Parameters
		loadVars();
		
		
		function loadVars() {
			
			if (typeof JSpyroColorBackground !== 'undefined') {
				_root.JSpyroColorBackground = JSpyroColorBackground;
			}
			if (typeof JSpyroScaling !== 'undefined') {
				_root.JSpyroScaling = JSpyroScaling;
			}	
			if (typeof JSpyroSpeed !== 'undefined') {
				_root.JSpyroSpeed = JSpyroSpeed;
			}
			if (typeof JSpyroGIFQuality !== 'undefined') {
				_root.JSpyroGIFQuality = JSpyroGIFQuality;
			}
			if (typeof JSpyroGIFWorkers !== 'undefined') {
				_root.JSpyroGIFWorkers = JSpyroGIFWorkers;
			}
			if (typeof JSpyroGIFWidth !== 'undefined') {
				_root.JSpyroGIFWidth = JSpyroGIFWidth;
			}
			if (typeof JSpyroGIFHeight !== 'undefined') {
				_root.JSpyroGIFHeight = JSpyroGIFHeight;
			}	
			if (typeof JSpyroGIFFrameDelay !== 'undefined') {
				_root.JSpyroGIFFrameDelay = JSpyroGIFFrameDelay;
			}
			if (typeof JSpyroGIFGrain !== 'undefined') {
				_root.JSpyroGIFGrain = JSpyroGIFFrameDelay;
			}	
			if (typeof JSpyroRandomMode !== 'undefined') {
				_root.JSpyroRandomMode = JSpyroRandomMode;
			}
			if (typeof JSpyroHelpURL !== 'undefined') {
				_root.JSpyroHelpURL = JSpyroHelpURL;
			}
			if (typeof JSpyroRightObjHandleSize !== 'undefined') {
				_root.JSpyroRightObjHandleSize = JSpyroRightObjHandleSize;
			}
			if (typeof JSpyroRightColorObjHandle !== 'undefined') {
				_root.JSpyroRightColorObjHandle = JSpyroRightColorObjHandle;
			}
			if (typeof JSpyroRightPropPathSize !== 'undefined') {
				_root.JSpyroRightPropPathSize = JSpyroRightPropPathSize;
			}
			if (typeof JSpyroRightPoiStringSize !== 'undefined') {
				_root.JSpyroRightPoiStringSize = JSpyroRightPoiStringSize;
			}
			if (typeof JSpyroRightPoiRadius !== 'undefined') {
				_root.JSpyroRightPoiRadius = JSpyroRightPoiRadius;
			}
			if (typeof JSpyroRightHandPathSize !== 'undefined') {
				_root.JSpyroRightHandPathSize = JSpyroRightHandPathSize;
			}
			if (typeof JSpyroLeftObjHandleSize !== 'undefined') {
				_root.JSpyroLeftObjHandleSize = JSpyroLeftObjHandleSize;
			}
			if (typeof JSpyroLeftColorObjHandle !== 'undefined') {
				_root.JSpyroLeftColorObjHandle = JSpyroLeftColorObjHandle;
			}
			if (typeof JSpyroLeftPropPathSize !== 'undefined') {
				_root.JSpyroLeftPropPathSize = JSpyroLeftPropPathSize;
			}
			if (typeof JSpyroLeftPoiStringSize !== 'undefined') {
				_root.JSpyroLeftPoiStringSize = JSpyroLeftPoiStringSize;
			}
			if (typeof JSpyroLeftPoiRadius !== 'undefined') {
				_root.JSpyroLeftPoiRadius = JSpyroLeftPoiRadius;
			}
			if (typeof JSpyroLeftHandPathSize !== 'undefined') {
				_root.JSpyroLeftHandPathSize = JSpyroLeftHandPathSize;
			}
			if (typeof JSpyroRightObjStrokeSize !== 'undefined') {
				_root.JSpyroRightObjStrokeSize = JSpyroRightObjStrokeSize;
			}
			if (typeof JSpyroLeftObjStrokeSize !== 'undefined') {
				_root.JSpyroLeftObjStrokeSize = JSpyroLeftObjStrokeSize;
			}
			if (typeof JSpyroClockSpeedRatio !== 'undefined') {
				_root.JSpyroClockSpeedRatio = JSpyroClockSpeedRatio;
			}
			if (typeof JSpyroSetClockSpeedRatio !== 'undefined') {
				_root.JSpyroSetClockSpeedRatio = JSpyroSetClockSpeedRatio;
			}	
			if (typeof JSpyroCleaningMode !== 'undefined') {
				_root.JSpyroCleaningMode = JSpyroCleaningMode;
			}	
			if (typeof JSpyroNbColorTransform !== 'undefined') {
				_root.JSpyroLoadXMLFileInput = JSpyroNbColorTransform;
			}		
			if (typeof JSpyroXMLSceneMode !== 'undefined') {
				_root.JSpyroXMLSceneMode = JSpyroXMLSceneMode;
			}
			
		}
		
		
		if (_root.JSpyroGoPage=="one") {
			this.gotoAndStop("one");
		} else {
			this.gotoAndStop("two");
		}
	}
	this.frame_1 = function() {
		//##############################################################################
		//## juggleSpyro                                                              ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//## Copyright (C) 2014-2020  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
		//##                                                                          ##
		//##                                                                          ##
		//## This program is free software; you can redistribute it and/or modify it  ##
		//## under the terms of the GNU General Public License version 3 as           ##
		//## published by the Free Software Foundation; version 3.                    ##
		//##                                                                          ##
		//## This program is distributed in the hope that it will be useful, but      ##
		//## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
		//## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
		//## General Public License for more details.                                 ##
		//##                                                                          ##
		//##############################################################################
		
		_root = this;
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Global Parameters / Variables
		/////////////////////////////////////////////////////////////////////////////////////////
		var backgroundColor = _root.JSpyroColorBackground;
		var axisColor = 'rgba(175,175,175,1)';
		var pauseMode = false;
		var displayWidth = stage.canvas.width/stage.scaleX;
		var displayHeight = stage.canvas.height/stage.scaleY;
		var animTimer;
		var animSpeedValueMax = 100;
		var animSpeedValue = _root.JSpyroSpeed;
		var animRunning = false;
		var scaling = _root.JSpyroScaling;
		var color_Selected = 'bt_color_background';
		var RandomSceneMode = false;
		var XMLSceneMode = false;
		var loadXMLFile = null;
		var loadXMLFileInput = _root.JSpyroLoadXMLFileInput;
		var XMLScenesCpt = 0;
		var XMLScenariosCpt = 0;
		var XMLAnimationName = "";
		var XMLScenarioName = "";
		var XMLSceneName = "";
		var XMLScenarioNbloops = 1;
		var XMLAnimationNbloops = -1;
		var XMLSceneNbloops = 1;
		var cur_XMLScenarioNbloops = 0;
		var cur_XMLAnimationNbloops = 0;
		var cur_XMLSceneNbloops = 0;
		var GIFEncoder;
		var GIFGrain = _root.JSpyroGIFGrain;
		var GIFGrainCpt = 0;
		var GIFCpt = 0;
		var GIFEncoding = false;
		var GIFQuality = _root.JSpyroGIFQuality;
		var GIFWorkers = _root.JSpyroGIFWorkers;
		var GIFWidth = _root.JSpyroGIFWidth;
		var GIFHeight = _root.JSpyroGIFHeight;
		var GIFFrameDelay = _root.JSpyroGIFFrameDelay;
		var helpURL = _root.JSpyroHelpURL;
		var clockSpeedRatio = _root.JSpyroClockSpeedRatio;
		var setClockSpeedRatio = _root.JSpyroSetClockSpeedRatio;
		var cleaningMode = _root.JSpyroCleaningMode;
		
		var CptColorTransform_left= 0;
		var CptColorTransform_right= 0;
		var NbColorTransform= _root.JSpyroNbColorTransform;
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Right Parameters / Variables
		/////////////////////////////////////////////////////////////////////////////////////////
		var right_ratio = -4;
		var right_shadowMode = false;
		var right_bluringMode = true;
		var right_cleaningMode = true;
		var right_armWay = "out";
		var right_showAxis = false;
		var right_nbloops = -1;
		var right_clockSpeed = 2;
		var right_setColorFilter = false;
		var right_cur_nbloops = 0;
		
		//// Axis Parameters
		var right_axisShape = new createjs.Shape();
		var right_axisInitdx = 340;
		var right_axisInitdy = 300;
		
		//// Hand Parameters
		var right_armShape = new createjs.Shape();
		var right_armLength = 100;
		var right_handPathColor = 'rgba(0,255,0,1)';
		var right_handPathClock = 0;
		var right_handPathStart = 0;
		var right_handPathEnd = 360;
		var right_handPathdx;
		var right_handPathdy;
		var right_armInitdx = right_axisInitdx;
		var right_armInitdy = right_axisInitdy;
		var right_armAngle = 0;
		var right_handPathSize = _root.JSpyroRightHandPathSize;
		var right_handPathViewMode = 2;
		var right_armDisplay = new createjs.Container();
		var right_armBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_armBitmap = new createjs.Bitmap(right_armBitmapData.canvas);
		
		//// Prop Path Parameters
		var right_propShape = new createjs.Shape();
		var right_propLength = 50;
		var right_objStrokeSize = _root.JSpyroRightObjStrokeSize;
		var right_propPathColor = 'rgba(226,0,0,1)';
		var right_propPathdx;
		var right_propPathdy;
		var right_propInitdx = right_axisInitdx;
		var right_propInitdy = right_axisInitdy;
		var right_propAngle = 0;
		var right_propChoice = 4;
		var right_propPathSize = _root.JSpyroRightPropPathSize;
		var right_propPathViewMode = 3;
		var right_propPathDisplay = new createjs.Container();
		var right_propPathBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_propPathBitmap = new createjs.Bitmap(right_propPathBitmapData.canvas);
		
		//// Prop Object Parameters
		var right_objHandleColor = _root.JSpyroRightColorObjHandle;
		var right_objHandleShape = new createjs.Shape(); // A Basic shape used by object (ex string in poi, or club handle)
		var right_objHandleSize = _root.JSpyroRightObjHandleSize;
		var right_poiStringSize = _root.JSpyroRightPoiStringSize;
		var right_poiRadius = _root.JSpyroRightPoiRadius;
		var right_objBodyShape;
		var right_objDisplay = new createjs.Container();
		var right_objBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_objBitmap = new createjs.Bitmap(right_objBitmapData.canvas);
		
		//// Misc
		var right_armShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var right_propShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var right_armBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var right_propBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var right_colorFilter = 'rgba(252,242,229,1)';
		var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
		var col_s = col.split(",");
		var right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		//var right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Left Parameters / Variables
		/////////////////////////////////////////////////////////////////////////////////////////
		var left_ratio = -4;
		var left_shadowMode = false;
		var left_bluringMode = true;
		var left_cleaningMode = true;
		var left_armWay = "out";
		var left_showAxis = false;
		var left_nbloops = -1;
		var left_clockSpeed = 2;
		if(setClockSpeedRatio == true)
		{
			left_clockSpeed = right_clockSpeed * clockSpeedRatio;
		}
		var left_setColorFilter = false;
		var left_cur_nbloops = 0;
		
		//// Axis Parameters
		var left_axisShape = new createjs.Shape();
		var left_axisInitdx = 450;
		var left_axisInitdy = 300;
		
		//// Hand Parameters
		var left_armShape = new createjs.Shape();
		var left_armLength = 100;
		var left_handPathColor = 'rgba(0,255,0,1)';
		var left_handPathClock = 0;
		var left_handPathStart = 0;
		var left_handPathEnd = 360;
		var left_handPathdx;
		var left_handPathdy;
		var left_armInitdx = left_axisInitdx;
		var left_armInitdy = left_axisInitdy;
		var left_armAngle = 0;
		var left_handPathSize = _root.JSpyroLeftHandPathSize;
		var left_handPathViewMode = 2;
		var left_armDisplay = new createjs.Container();
		var left_armBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var left_armBitmap = new createjs.Bitmap(left_armBitmapData.canvas);
		
		//// Prop Path Parameters
		var left_propShape = new createjs.Shape();
		var left_propLength = 50;
		var left_objStrokeSize = _root.JSpyroLeftObjStrokeSize;
		var left_propPathColor = 'rgba(226,0,0,1)';
		var left_propPathdx;
		var left_propPathdy;
		var left_propInitdx = left_axisInitdx;
		var left_propInitdy = left_axisInitdy;
		var left_propAngle = 0;
		var left_propChoice = 4;
		var left_propPathSize = _root.JSpyroLeftPropPathSize;
		var left_propPathViewMode = 3;
		var left_propPathDisplay = new createjs.Container();
		var left_propPathBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var left_propPathBitmap = new createjs.Bitmap(left_propPathBitmapData.canvas);
		
		//// Prop Object Parameters
		var left_objHandleColor = _root.JSpyroLeftColorObjHandle;
		var left_objHandleShape = new createjs.Shape(); // A Basic shape used by object (ex string in poi, or club handle)
		var left_objHandleSize = _root.JSpyroLeftObjHandleSize;
		var left_poiStringSize = _root.JSpyroLeftPoiStringSize;
		var left_poiRadius = _root.JSpyroLeftPoiRadius;
		var left_objBodyShape;
		var left_objDisplay = new createjs.Container();
		var left_objBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var left_objBitmap = new createjs.Bitmap(left_objBitmapData.canvas);
		
		//// Misc
		var left_armShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var left_propShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var left_armBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var left_propBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var left_colorFilter = 'rgba(252,242,229,1)';
		var col = left_colorFilter.substring(5, left_colorFilter.length - 1);
		var col_s = col.split(",");
		var left_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		//var left_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Right Panel (On the Left)
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if (!this.bt_right_propChoice_change_cbk) {
			function bt_right_propChoice_change(evt) {
				if (right_objBodyShape != null) {
					right_objDisplay.removeChild(right_objBodyShape);
					right_objBodyShape = null;
				}
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
				right_propChoice = evt.target.value
			}
			$("#dom_overlay_container").on("change", "#bt_right_propChoice", bt_right_propChoice_change.bind(this));
			this.bt_right_propChoice_change_cbk = true;
		}
		
		
		if (!this.bt_right_armWay_change_cbk) {
			function bt_right_armWay_change(evt) {
				right_armWay = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_armWay", bt_right_armWay_change.bind(this));
			this.bt_right_armWay_change_cbk = true;
		}
		
		
		if (!this.bt_right_propPathViewMode_cbk) {
			function bt_right_propPathViewMode_change(evt) {
				right_propPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_propPathViewMode", bt_right_propPathViewMode_change.bind(this));
			this.bt_right_propPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_right_handPathViewMode_cbk) {
			function bt_right_handPathViewMode_change(evt) {
				right_handPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_handPathViewMode", bt_right_handPathViewMode_change.bind(this));
			this.bt_right_handPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_right_ratio_change_cbk) {
			function bt_right_ratio_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_ratio = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_ratio", bt_right_ratio_change.bind(this));
			this.bt_right_ratio_change_cbk = true;
		}
		
		
		if (!this.bt_right_nbloops_change_cbk) {
			function bt_right_nbloops_change(evt) {
				var regex = /[^0-9]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_nbloops = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_nbloops", bt_right_nbloops_change.bind(this));
			this.bt_right_nbloops_change_cbk = true;
		}
		
		
		if (!this.bt_right_armAngle_change_cbk) {
			function bt_right_armAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_armAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_armAngle", bt_right_armAngle_change.bind(this));
			this.bt_right_armAngle_change_cbk = true;
		}
		
		
		if (!this.bt_right_propAngle_change_cbk) {
			function bt_right_propAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_propAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_propAngle", bt_right_propAngle_change.bind(this));
			this.bt_right_propAngle_change_cbk = true;
		}
		
		
		if (!this.bt_right_shadow_change_cbk) {
			function bt_right_shadow_change(evt) {
				right_shadowMode = !right_shadowMode;
				update_right_shadow();
			}
			$("#dom_overlay_container").on("change", "#bt_right_shadow", bt_right_shadow_change.bind(this));
			this.bt_right_shadow_change_cbk = true;
		}
		
		
		if (!this.bt_right_bluring_change_cbk) {
			function bt_right_bluring_change(evt) {
				right_bluringMode = !right_bluringMode;
				update_right_bluring();
			}
			$("#dom_overlay_container").on("change", "#bt_right_bluring", bt_right_bluring_change.bind(this));
			this.bt_right_bluring_change_cbk = true;
		}
		
		
		if (!this.bt_right_prop_setColorFilter_change_cbk) {
			function bt_right_prop_setColorFilter_change(evt) {
				right_setColorFilter = !right_setColorFilter;
			}
			$("#dom_overlay_container").on("change", "#bt_right_prop_setColorFilter", bt_right_prop_setColorFilter_change.bind(this));
			this.bt_right_prop_setColorFilter_change_cbk = true;
		}
		
		
		if (!this.bt_right_showAxis_change_cbk) {
			function bt_right_showAxis_change(evt) {
				right_showAxis = !right_showAxis;
				right_axisShape.visible = right_showAxis;		
			}
			$("#dom_overlay_container").on("change", "#bt_right_showAxis", bt_right_showAxis_change.bind(this));
			this.bt_right_showAxis_change_cbk = true;
		}
		
		
		if (!this.bt_right_cleaning_change_cbk) {
			function bt_right_cleaning_change(evt) {
				right_cleaningMode = !right_cleaningMode;
			}
			$("#dom_overlay_container").on("change", "#bt_right_cleaning", bt_right_cleaning_change.bind(this));
			this.bt_right_cleaning_change_cbk = true;
		}
		
		
		if (!this.bt_slider_change_cbk) {
			bt_slider_listener = this.on('bt_slider', function (evt) {
				var slider_selected = evt.initiator;
				updateFromSlider(slider_selected);
			});
			this.bt_slider_change_cbk = true;
		}
		
		
		function updateFromSlider(slider) {
			// Get the Value and update slider according to it 	
			if (slider == 'bt_right_axisInitdx') {
				right_axisInitdx = _root.bt_right_axisInitdx.getValue();
				drawAxis_right();
				right_armInitdx = right_axisInitdx;
				right_propInitdx = right_axisInitdx;
			} else if (slider == 'bt_right_axisInitdy') {
				right_axisInitdy = _root.bt_right_axisInitdy.getValue();
				drawAxis_right();
				right_armInitdy = right_axisInitdy;
				right_propInitdy = right_axisInitdy;
			} else if (slider == 'bt_right_armLength') {
				right_armLength = _root.bt_right_armLength.getValue();
			} else if (slider == 'bt_right_propLength') {
				right_propLength = _root.bt_right_propLength.getValue();
			} else if (slider == 'bt_right_clockSpeed') {
				right_clockSpeed = _root.bt_right_clockSpeed.getValue();
				if(setClockSpeedRatio == true)
				{		
					left_clockSpeed = right_clockSpeed * clockSpeedRatio;
					_root.bt_left_clockSpeed.setSlider(left_clockSpeed);
				}
			} else if (slider == 'bt_left_axisInitdx') {
				left_axisInitdx = _root.bt_left_axisInitdx.getValue();
				drawAxis_left();
				left_armInitdx = left_axisInitdx;
				left_propInitdx = left_axisInitdx;
			} else if (slider == 'bt_left_axisInitdy') {
				left_axisInitdy = _root.bt_left_axisInitdy.getValue();
				drawAxis_left();
				left_armInitdy = left_axisInitdy;
				left_propInitdy = left_axisInitdy;
			} else if (slider == 'bt_left_armLength') {
				left_armLength = _root.bt_left_armLength.getValue();
			} else if (slider == 'bt_left_propLength') {
				left_propLength = _root.bt_left_propLength.getValue();
			} else if (slider == 'bt_left_clockSpeed') {
				if(setClockSpeedRatio == false)
				{		
					left_clockSpeed = _root.bt_left_clockSpeed.getValue();
				}
			} else if (slider == 'bt_speed') {
				animSpeedValue = _root.bt_speed.getValue();
				createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;
			} else if (slider == 'bt_scale') {
				scaling = _root.bt_scale.getValue();
				update_scaling(scaling);
			}
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Left Panel (On the Right)
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if (!this.bt_left_propChoice_change_cbk) {
			function bt_left_propChoice_change(evt) {
				if (left_objBodyShape != null) {
					left_objDisplay.removeChild(left_objBodyShape);
					left_objBodyShape = null;
				}
				left_objHandleShape.graphics.clear();
				left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
				left_propChoice = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_left_propChoice", bt_left_propChoice_change.bind(this));
			this.bt_left_propChoice_change_cbk = true;
		}
		
		
		if (!this.bt_left_armWay_change_cbk) {
			function bt_left_armWay_change(evt) {
				left_armWay = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_left_armWay", bt_left_armWay_change.bind(this));
			this.bt_left_armWay_change_cbk = true;
		}
		
		
		if (!this.bt_left_propPathViewMode_cbk) {
			function bt_left_propPathViewMode_change(evt) {
				left_propPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_left_propPathViewMode", bt_left_propPathViewMode_change.bind(this));
			this.bt_left_propPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_left_handPathViewMode_cbk) {
			function bt_left_handPathViewMode_change(evt) {
				left_handPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_left_handPathViewMode", bt_left_handPathViewMode_change.bind(this));
			this.bt_left_handPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_left_ratio_change_cbk) {
			function bt_left_ratio_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;		
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				left_ratio = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_left_ratio", bt_left_ratio_change.bind(this));
			this.bt_left_ratio_change_cbk = true;
		}
		
		
		if (!this.bt_left_nbloops_change_cbk) {
			function bt_left_nbloops_change(evt) {		
				var regex = /[^0-9]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				left_nbloops = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_left_nbloops", bt_left_nbloops_change.bind(this));
			this.bt_left_nbloops_change_cbk = true;
		}
		
		
		if (!this.bt_left_armAngle_change_cbk) {
			function bt_left_armAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				left_armAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_left_armAngle", bt_left_armAngle_change.bind(this));
			this.bt_left_armAngle_change_cbk = true;
		}
		
		
		if (!this.bt_left_propAngle_change_cbk) {
			function bt_left_propAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				left_propAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_left_propAngle", bt_left_propAngle_change.bind(this));
			this.bt_left_propAngle_change_cbk = true;
		}
		
		
		if (!this.bt_left_shadow_change_cbk) {
			function bt_left_shadow_change(evt) {
				left_shadowMode = !left_shadowMode;
				update_left_shadow();
			}
			$("#dom_overlay_container").on("change", "#bt_left_shadow", bt_left_shadow_change.bind(this));
			this.bt_left_shadow_change_cbk = true;
		}
		
		
		if (!this.bt_left_bluring_change_cbk) {
			function bt_left_bluring_change(evt) {
				left_bluringMode = !left_bluringMode;
				update_left_bluring();
			}
			$("#dom_overlay_container").on("change", "#bt_left_bluring", bt_left_bluring_change.bind(this));
			this.bt_left_bluring_change_cbk = true;
		}
		
		
		if (!this.bt_left_prop_setColorFilter_change_cbk) {
			function bt_left_prop_setColorFilter_change(evt) {
				left_setColorFilter = !left_setColorFilter;
			}
			$("#dom_overlay_container").on("change", "#bt_left_prop_setColorFilter", bt_left_prop_setColorFilter_change.bind(this));
			this.bt_left_prop_setColorFilter_change_cbk = true;
		}
		
		
		if (!this.bt_left_showAxis_change_cbk) {
			function bt_left_showAxis_change(evt) {
				left_showAxis = !left_showAxis;
				left_axisShape.visible = left_showAxis;
			}
			$("#dom_overlay_container").on("change", "#bt_left_showAxis", bt_left_showAxis_change.bind(this));
			this.bt_left_showAxis_change_cbk = true;
		}
		
		
		if (!this.bt_left_cleaning_change_cbk) {
			function bt_left_cleaning_change(evt) {
				left_cleaningMode = !left_cleaningMode;
			}
			$("#dom_overlay_container").on("change", "#bt_left_cleaning", bt_left_cleaning_change.bind(this));
			this.bt_left_cleaning_change_cbk = true;
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Bottom Panel 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if (!this.colorSelectShow_change_cbk) {
			colorSelectShow_listener = this.on('colorSelectShow', function (evt) {
				_root.ColorSelector.visible = true;
				_root.color_Selected = evt.initiator;
				stage.enableMouseOver(10);
			});
			this.colorSelectShow_change_cbk = true;
		}
		
		// We will switch the ColorSelector to stage after creation 
		// to have it on top layer since there in no z-index possibility
		//colorSelect_listener=this.on('colorSelect', function(evt) {			
		//updateFromColor(_root.color_Selected,evt.rgba);		
		//_root.ColorSelector.visible = false;		
		//stage.enableMouseOver(0);
		//});
		if (!this.colorSelect_change_cbk) {
			colorSelect_listener = stage.on('colorSelect', function (evt) {
				updateFromColor(_root.color_Selected, evt.rgba);
				_root.ColorSelector.visible = false;
				stage.enableMouseOver(0);
			});
			this.colorSelect_change_cbk=true;
		}
		
		
		function updateFromColor(colorSelected, color) {
		
			// Get Selected Color and Update according to it 
			if (colorSelected == 'bt_color_background') {
				backgroundColor = color;
				canvas.style.backgroundColor = color;
				_root.bt_color_background.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_color_propPath') {
				right_propPathColor = color;
				right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
				_root.bt_right_color_propPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_color_handPath') {
				right_handPathColor = color;
				right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
				_root.bt_right_color_handPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_prop_color_filter') {
				right_colorFilter = color;
				_root.bt_right_prop_color_filter.shape_1.graphics._fill.style = right_colorFilter;
				var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
				var col_s = col.split(",");
				right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);		
				//right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			} else if (colorSelected == 'bt_left_color_propPath') {
				left_propPathColor = color;
				left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
				_root.bt_left_color_propPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_left_color_handPath') {
				left_handPathColor = color;
				left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
				_root.bt_left_color_handPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_left_prop_color_filter') {
				left_colorFilter = color;
				_root.bt_left_prop_color_filter.shape_1.graphics._fill.style = left_colorFilter;
				var col = left_colorFilter.substring(5, left_colorFilter.length - 1);
				var col_s = col.split(",");
				left_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
				//left_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			}
		}
		
		if (!this.bt_cleaning_change_cbk) {
			function bt_cleaning_change(evt) {
				cleaningMode = !cleaningMode;
			}
			$("#dom_overlay_container").on("change", "#bt_cleaning", bt_cleaning_change.bind(this));
			this.bt_cleaning_change_cbk = true;
		}
		
		
		if (!this.bt_stop_change_cbk) {
			bt_stop_listener = this.on('bt_stop', function (evt) {
				RandomSceneMode = false;
				XMLSceneMode = false;
				right_handPathStart = 0;
				right_handPathEnd = 360;
				left_handPathStart = 0;
				left_handPathEnd = 360;
				stop();
			});
			this.bt_stop_change_cbk=true;
		}
		
		
		if (!this.bt_start_change_cbk) {
			bt_start_listener = this.on('bt_start', function (evt) {
				start();
			});
			this.bt_start_change_cbk=true;
		}
		
		
		if (!this.bt_pause_change_cbk) {
			bt_pause_listener = this.on('bt_pause', function (evt) {
				pause();
			});
			this.bt_pause_change_cbk=true;
		}
		
		
		if (!this.bt_reset_change_cbk) {
			bt_reset_listener = this.on('bt_reset', function (evt) {
				reset();
			});
			this.bt_reset_change_cbk=true;
		}
		
		
		if (!this.bt_target_change_cbk) {
			bt_target_listener = this.on('bt_target', function (evt) {
				join_axis();
			});
			this.bt_target_change_cbk=true;
		}
		
		
		if (!this.bt_random_anim_change_cbk) {
			bt_random_anim_listener = this.on('bt_random_anim', function (evt) {
				random_anim();
			});
			this.bt_random_anim_change_cbk=true;
		}
		
		
		if (!this.bt_credits_show_change_cbk) {
			bt_credits_show_listener = this.on('bt_credits_show', function (evt) {
				_root.credits.visible = !_root.credits.visible;
			});
			this.bt_credits_show_change_cbk=true;
		}
		
		
		if (!this.bt_clean_change_cbk) {
			bt_clean_listener = this.on('bt_clean', function (evt) {
				clean();		
			});
			this.bt_clean_show_change_cbk=true;
		}
		
		
		if (!this.bt_exportImg_change_cbk) {
			bt_exportImg_listener = this.on('bt_exportImg', function (evt) {
				exportPNG();
			});
			this.bt_exportImg_change_cbk=true;
		}
		
		
		if (!this.bt_help_show_change_cbk) {
			bt_help_show_listener = this.on('bt_help_show', function (evt) {
				help_show();
			});
			this.bt_help_show_change_cbk=true;
		}
		
		
		if (!this.bt_loadXMLFile_change_cbk) {
			bt_loadXMLFile_listener = this.on('bt_loadXMLFile', function (evt) {
				loadXML();
			});
			this.bt_loadXMLFile_show_change_cbk=true;
		}
		
		
		if (!this.bt_runXML_change_cbk) {
			bt_runXML_listener = this.on('bt_runXML', function (evt) {
				runXML();
			});
			this.bt_runXML_change_cbk=true;
		}
		
		
		if (!this.bt_exportXML_change_cbk) {
			bt_exportXML_listener = this.on('bt_exportXML', function (evt) {
				exportXML();
			});
			this.bt_exportXML_change_cbk=true;
		}
		
		
		if (!this.bt_go_two_change_cbk) {		
			bt_go_two_listener = this.on('bt_go_two', function (evt) {
				purge_scene();
				_root.gotoAndStop("two");
			});
			this.bt_go_two_change_cbk=true;
		}
		
		
		if (!this.bt_go_one_change_cbk) {
			bt_go_one_listener = this.on('bt_go_one', function (evt) {
				purge_scene();
				_root.gotoAndStop("one");
			});
			this.bt_go_one_change_cbk=true;
		}
		
		
		if (!this.bt_start_record_change_cbk) {
			bt_start_record_listener = this.on('bt_start_record', function (evt) {
				startGIFEncoding();
			});
			this.bt_start_record_change_cbk=true;
		}
		
		
		if (!this.bt_stop_record_change_cbk) {
			bt_stop_record_listener = this.on('bt_stop_record', function (evt) {
				stopGIFEncoding();
			});
			this.bt_stop_record_change_cbk=true;
		}
		
		
		if(!this.bt_GIFGrain_change_cbk) {	
			function bt_GIFGrain_change(evt) {			
				var regex = /[^0-9]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				GIFGrain = evt.target.value;	
			}
			$("#dom_overlay_container").on("keyup", "#bt_GIFGrain", bt_GIFGrain_change.bind(this));
			this.bt_GIFGrain_change_cbk = true;
		}
		
		
		if(!this.bt_clockSpeedRatio_change_cbk) {	
			function bt_clockSpeedRatio_change(evt) {			
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				clockSpeedRatio = evt.target.value;
				if(setClockSpeedRatio == true)
				{
					left_clockSpeed = clockSpeedRatio * right_clockSpeed;
					_root.bt_left_clockSpeed.setSlider(left_clockSpeed);			
				}
			}
			$("#dom_overlay_container").on("keyup", "#bt_clockSpeedRatio", bt_clockSpeedRatio_change.bind(this));
			this.bt_clockSpeedRatio_change_cbk = true;
		}
		
		
		if (!this.bt_setClockSpeedRatio_change_cbk) {	
			function bt_setClockSpeedRatio_change(evt) {
					
				setClockSpeedRatio = !setClockSpeedRatio;						
				if(setClockSpeedRatio == true)
				{
					_root.bt_left_clockSpeed.SliderBar.shape.graphics._fill.style = "rgba(226,0,0,1)";			
					setTimeout(function () { 		
						_root.bt_left_clockSpeed.enable(false);	
						left_clockSpeed = right_clockSpeed * clockSpeedRatio;
						_root.bt_left_clockSpeed.setSlider(left_clockSpeed);	
					}, 0); 
				}
				else
				{			
					_root.bt_left_clockSpeed.SliderBar.shape.graphics._fill.style = "rgba(204,204,204,1)";	
					setTimeout(function () { 		
						_root.bt_left_clockSpeed.enable(true);					
					}, 0);
				}		
			}
			$("#dom_overlay_container").on("change", "#bt_setClockSpeedRatio", bt_setClockSpeedRatio_change.bind(this));
			this.bt_setClockSpeedRatio_change_cbk = true;
		}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		/// Scene Handling
		/////////////////////////////////////////////////////////////////////////////////////////
		
		function build_scene_right() {
			stage.addChild(right_axisShape);
			right_armDisplay.addChild(right_armShape);
			stage.addChild(right_armBitmap);
			right_propPathDisplay.addChild(right_propShape);
			stage.addChild(right_propPathBitmap);
			stage.addChild(right_objHandleShape);
			stage.addChild(right_objBitmap);
		}
		
		
		function build_scene_left() {
			stage.addChild(left_axisShape);
			left_armDisplay.addChild(left_armShape);
			stage.addChild(left_armBitmap);
			left_propPathDisplay.addChild(left_propShape);
			stage.addChild(left_propPathBitmap);
			stage.addChild(left_objHandleShape);
			stage.addChild(left_objBitmap);
		}
		
		
		function build_scene() {
			build_scene_right();
			build_scene_left();
			stage.addChild(_root.ColorSelector);
		}
		
		
		function purge_scene_right() {
			right_armShape.uncache();
			right_armShape.graphics.clear();
			right_armDisplay.uncache();
			right_armDisplay.removeChild(right_armShape);
			stage.removeChild(right_armBitmap);
			
			right_propShape.uncache();
			right_propShape.graphics.clear();
			right_propPathDisplay.uncache();
			right_propPathDisplay.removeChild(right_propShape);
			stage.removeChild(right_propPathBitmap);
			
			right_objHandleShape.graphics.clear();
			if (right_objBodyShape != null) {
				right_objBodyShape.uncache();
				right_objBodyShape.graphics.clear();
				right_objDisplay.removeChild(right_objBodyShape);
				right_objBodyShape = null;
			}	
			right_objDisplay.uncache();	
			stage.removeChild(right_objBitmap);
		
			stage.removeChild(right_objHandleShape);
		
			right_axisShape.graphics.clear();	
			stage.removeChild(right_axisShape);
		
			$("#dom_overlay_container").off("change", "#bt_right_propChoice");
			_root.bt_right_propChoice_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_armWay");
			_root.bt_right_armWay_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_propPathViewMode");
			_root.bt_right_propPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_handPathViewMode");
			_root.bt_right_handPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_ratio");
			_root.bt_right_ratio_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_nbloops");
			_root.bt_right_nbloops_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_armAngle");
			_root.bt_right_armAngle_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_propAngle");
			_root.bt_right_propAngle_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_shadow");
			_root.bt_right_shadow_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_bluring");
			_root.bt_right_bluring_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_prop_setColorFilter");
			_root.bt_right_prop_setColorFilter_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_showAxis");
			_root.bt_right_showAxis_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_cleaning");
			_root.bt_right_cleaning_change_cbk = false;
		}
		
		
		function purge_scene_left() {
			left_armShape.uncache();
			left_armShape.graphics.clear();
			left_armDisplay.uncache();
			left_armDisplay.removeChild(left_armShape);
			stage.removeChild(left_armBitmap);
			
			left_propShape.uncache();
			left_propShape.graphics.clear();
			left_propPathDisplay.uncache();
			left_propPathDisplay.removeChild(left_propShape);
			stage.removeChild(left_propPathBitmap);
			
			left_objHandleShape.graphics.clear();
			if (left_objBodyShape != null) {
				left_objBodyShape.uncache();
				left_objBodyShape.graphics.clear();
				left_objDisplay.removeChild(left_objBodyShape);
				left_objBodyShape = null;
			}	
			left_objDisplay.uncache();	
			stage.removeChild(left_objBitmap);
		
			stage.removeChild(left_objHandleShape);
		
			left_axisShape.graphics.clear();	
			stage.removeChild(left_axisShape);
		
			$("#dom_overlay_container").off("change", "#bt_left_propChoice");
			_root.bt_left_propChoice_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_armWay");
			_root.bt_left_armWay_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_propPathViewMode");
			_root.bt_left_propPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_handPathViewMode");
			_root.bt_left_handPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_left_ratio");
			_root.bt_left_ratio_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_left_nbloops");
			_root.bt_left_nbloops_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_left_armAngle");
			_root.bt_left_armAngle_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_left_propAngle");
			_root.bt_left_propAngle_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_shadow");
			_root.bt_left_shadow_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_bluring");
			_root.bt_left_bluring_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_prop_setColorFilter");
			_root.bt_left_prop_setColorFilter_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_showAxis");
			_root.bt_left_showAxis_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_left_cleaning");
			_root.bt_left_cleaning_change_cbk = false;
		}
		
		
		function purge_scene() {
			stop();
			purge_scene_right();
			purge_scene_left();
		
			stage.removeChild(_root.ColorSelector);
		
			_root.off('bt_slider', bt_slider_listener);
			_root.bt_slider_change_cbk = false;
			_root.off('colorSelectShow', colorSelectShow_listener);
			_root.colorSelectShow_change_cbk = false;
			_root.off('bt_stop', bt_stop_listener);
			_root.bt_stop_change_cbk = false;
			_root.off('bt_start', bt_start_listener);
			_root.bt_start_change_cbk = false;
			_root.off('bt_pause', bt_pause_listener);
			_root.bt_pause_change_cbk = false;
			_root.off('bt_reset', bt_reset_listener);
			_root.bt_reset_change_cbk = false;
			_root.off('bt_target', bt_target_listener);
			_root.bt_target_change_cbk = false;
			_root.off('bt_random_anim', bt_random_anim_listener);
			_root.bt_random_anim_change_cbk = false;
			_root.off('bt_credits_show', bt_credits_show_listener);
			_root.bt_credits_show_change_cbk = false;
			_root.off('bt_clean', bt_clean_listener);
			_root.bt_clean_change_cbk = false;
			_root.off('bt_exportImg', bt_exportImg_listener);
			_root.bt_exportImg_change_cbk = false;
			_root.off('bt_runXML', bt_runXML_listener);
			_root.bt_runXML_change_cbk = false;
			_root.off('bt_exportXML', bt_exportXML_listener);
			_root.bt_exportXML_change_cbk = false;
			_root.off('bt_loadXMLFile', bt_loadXMLFile_listener);
			_root.bt_loadXMLFile_change_cbk = false;
			_root.off('bt_help_show', bt_help_show_listener);
			_root.bt_help_show_change_cbk = false;
			_root.off('bt_go_two', bt_go_two_listener);
			_root.bt_go_two_change_cbk = false;	
			_root.off('bt_go_one', bt_go_one_listener);	
			_root.bt_go_one_change_cbk = false;
			_root.off('bt_start_record', bt_start_record_listener);
			_root.bt_start_record_change_cbk = false;
			_root.off('bt_stop_record', bt_stop_record_listener);
			_root.bt_stop_record_change_cbk = false;
			
			if(GIFEncoding == true)
			{
				stopGIFEncoding();
			}	
			$("#dom_overlay_container").off("keyup", "#bt_GIFGrain");
			_root.bt_GIFGrain_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_clockSpeedRatio");
			_root.bt_clockSpeedRatio_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_setClockSpeedRatio");
			_root.bt_setClockSpeedRatio_change_cbk = false;	
			$("#dom_overlay_container").off("change", "#bt_cleaning");
			_root.bt_cleaning_change_cbk = false;	
			
			stage.off('colorSelect', colorSelect_listener);
			_root.colorSelect_change_cbk = false;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Functions 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		
		function clean_right() {
			_root.credits.visible = false;
			right_objHandleShape.graphics.clear();
			if (right_objBodyShape != null) {
				right_objBodyShape.uncache();
				right_objBodyShape.graphics.clear();
				right_objDisplay.removeChild(right_objBodyShape);
				right_objBodyShape = null;
			}
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
			right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_objDisplay.filters = [];
			right_objDisplay.cache(0, 0, displayWidth, displayHeight);
			right_objBitmapData.draw(right_objDisplay);
		
			right_armShape.uncache();
			right_armShape.graphics.clear();
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_armDisplay.filters = [];
			right_armDisplay.cache(0, 0, displayWidth, displayHeight);
			right_armBitmapData.draw(right_armDisplay);
		
			right_propShape.uncache();
			right_propShape.graphics.clear();
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_propPathDisplay.filters = [];
			right_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
			right_propPathBitmapData.draw(right_propPathDisplay);
		}
		
		
		function clean_left() {
			_root.credits.visible = false;
			left_objHandleShape.graphics.clear();
			if (left_objBodyShape != null) {
				left_objBodyShape.uncache();
				left_objBodyShape.graphics.clear();
				left_objDisplay.removeChild(left_objBodyShape);
				left_objBodyShape = null;
			}
			left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
			left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			left_objDisplay.filters = [];
			left_objDisplay.cache(0, 0, displayWidth, displayHeight);
			left_objBitmapData.draw(left_objDisplay);
		
			left_armShape.uncache();
			left_armShape.graphics.clear();
			left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
			left_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			left_armDisplay.filters = [];
			left_armDisplay.cache(0, 0, displayWidth, displayHeight);
			left_armBitmapData.draw(left_armDisplay);
		
			left_propShape.uncache();
			left_propShape.graphics.clear();
			left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
			left_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			left_propPathDisplay.filters = [];
			left_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
			left_propPathBitmapData.draw(left_propPathDisplay);
		
		}
		
		function clean () {
			clean_right();	
			clean_left();
		}
		
		
		function init_right() {
		
			// Init Parameters	
			right_ratio = -4;
			right_shadowMode = false;
			right_bluringMode = true;
			right_cleaningMode = true;
			right_armWay = "out";
			right_showAxis = false;
			right_nbloops = -1;
			right_clockSpeed = 2;
			if(setClockSpeedRatio == true)
			{
				left_clockSpeed = right_clockSpeed * clockSpeedRatio;
			}	
			right_setColorFilter = false;
			right_cur_nbloops = 0;
			right_axisInitdx = 340;
			right_axisInitdy = 300;
			right_armLength = 100;
			right_handPathColor = 'rgba(0,255,0,1)';
			right_handPathClock = 0;
			right_handPathStart = 0;
			right_handPathEnd = 360;
			right_armInitdx = right_axisInitdx;
			right_armInitdy = right_axisInitdy;
			right_armAngle = 0;
			right_handPathSize = _root.JSpyroRightHandPathSize;
			right_handPathViewMode = 2;
			right_propLength = 50;
			right_objStrokeSize = _root.JSpyroRightObjStrokeSize;
			right_propPathColor = 'rgba(226,0,0,1)';
			right_colorFilter = 'rgba(252,242,229,1)';
			right_propInitdx = right_axisInitdx;
			right_propInitdy = right_axisInitdy;
			right_propAngle = 0;
			right_propChoice = 4;
			right_propPathSize = _root.JSpyroRightPropPathSize;
			right_propPathViewMode = 3;
			right_objHandleColor = _root.JSpyroRightColorObjHandle;
			right_objHandleSize = _root.JSpyroRightObjHandleSize;
			right_poiStringSize = _root.JSpyroRightPoiStringSize;
			right_poiRadius = _root.JSpyroRightPoiRadius;
		
			//	if (right_objBodyShape!=null) {
			//		right_objDisplay.removeChild(right_objBodyShape);
			//		right_objBodyShape=null;
			//	}
		}
		
		
		function init_left() {
		
			// Init Parameters	
			left_ratio = -4;
			left_shadowMode = false;
			left_bluringMode = true;
			left_cleaningMode = true;
			left_armWay = "out";
			left_showAxis = false;
			left_nbloops = -1;
			if(setClockSpeedRatio == false) {		
				left_clockSpeed = 2;
				}
			left_setColorFilter = false;
			left_cur_nbloops = 0;
			left_axisInitdx = 450;
			left_axisInitdy = 300;
			left_armLength = 100;
			left_handPathColor = 'rgba(0,255,0,1)';
			left_handPathClock = 0;
			left_handPathStart = 0;
			left_handPathEnd = 360;
			left_armInitdx = left_axisInitdx;
			left_armInitdy = left_axisInitdy;
			left_armAngle = 0;
			left_handPathSize = _root.JSpyroLeftHandPathSize;
			left_handPathViewMode = 2;
			left_propLength = 50;
			left_objStrokeSize = _root.JSpyroLeftObjStrokeSize;
			left_propPathColor = 'rgba(226,0,0,1)';
			left_colorFilter = 'rgba(252,242,229,1)';
			left_propInitdx = left_axisInitdx;
			left_propInitdy = left_axisInitdy;
			left_propAngle = 0;
			left_propChoice = 4;
			left_propPathSize = _root.JSpyroLeftPropPathSize;
			left_propPathViewMode = 3;
			left_objHandleColor = _root.JSpyroLeftColorObjHandle;
			left_objHandleSize = _root.JSpyroLeftObjHandleSize;
			left_poiStringSize = _root.JSpyroLeftPoiStringSize;
			left_poiRadius = _root.JSpyroLeftPoiRadius;
		
			//	if (left_objBodyShape!=null) {
			//		left_objDisplay.removeChild(left_objBodyShape);
			//		left_objBodyShape=null;
			//	}	
		}
		
		
		function init() {
			backgroundColor = _root.JSpyroColorBackground;
			animSpeedValue = _root.JSpyroSpeed;
			scaling = _root.JSpyroScaling;
			RandomSceneMode = false;
			GIFGrain = _root.JSpyroGIFGrain;
			clockSpeedRatio = _root.JSpyroClockSpeedRatio;
			setClockSpeedRatio = _root.JSpyroSetClockSpeedRatio;	
			cleaningMode = _root.JSpyroCleaningMode;
			XMLScenesCpt = 0;
			XMLScenariosCpt = 0;
			XMLSceneMode = false;
			
			init_right();
			init_left();
			if(RandomSceneMode == true)
			{
				left_nbloops = 1;	
				right_nbloops = 1;	
			}
			setParameters();	
			
			_root.credits.visible = false;
			_root.ColorSelector.visible = false;	
		}
		
		
		function getParameters_right() {
		
			setTimeout(function () {
				right_propChoice = document.getElementById("bt_right_propChoice").value;
				right_armWay = document.getElementById("bt_right_armWay").value;
				right_ratio = document.getElementById("bt_right_ratio").value;
				right_nbloops = document.getElementById("bt_right_nbloops").value;
				right_armAngle = document.getElementById("bt_right_armAngle").value;
				right_propAngle = document.getElementById("bt_right_propAngle").value;
				right_propPathViewMode = document.getElementById("bt_right_propPathViewMode").value;
				right_handPathViewMode = document.getElementById("bt_right_handPathViewMode").value;
				right_setColorFilter = document.getElementById("bt_right_prop_setColorFilter").checked;
				right_shadowMode = document.getElementById("bt_right_shadow").checked;
				right_bluringMode = document.getElementById("bt_right_bluring").checked;
				right_showAxis = document.getElementById("bt_right_showAxis").checked;
				right_cleaningMode = document.getElementById("bt_right_cleaning").checked;
		
				// Get the Color Values and do related actions	
				updateFromColor('bt_right_color_handPath', right_handPathColor);
				updateFromColor('bt_right_color_propPath', right_propPathColor);
				updateFromColor('bt_right_prop_color_filter', right_colorFilter);
		
				// Get the Sliders Values and do related actions
				updateFromSlider('bt_right_axisInitdx');
				updateFromSlider('bt_right_axisInitdy');
				updateFromSlider('bt_right_clockSpeed');
				updateFromSlider('bt_right_armLength');
				updateFromSlider('bt_right_propLength');
			}, 0);
		}
		
		function getParameters_left() {
		
			setTimeout(function () {
				left_propChoice = document.getElementById("bt_left_propChoice").value;
				left_armWay = document.getElementById("bt_left_armWay").value;
				left_ratio = document.getElementById("bt_left_ratio").value;
				left_nbloops = document.getElementById("bt_left_nbloops").value;
				left_armAngle = document.getElementById("bt_left_armAngle").value;
				left_propAngle = document.getElementById("bt_left_propAngle").value;
				left_propPathViewMode = document.getElementById("bt_left_propPathViewMode").value;
				left_handPathViewMode = document.getElementById("bt_left_handPathViewMode").value;
				left_setColorFilter = document.getElementById("bt_left_prop_setColorFilter").checked;
				left_shadowMode = document.getElementById("bt_left_shadow").checked;
				left_bluringMode = document.getElementById("bt_left_bluring").checked;
				left_showAxis = document.getElementById("bt_left_showAxis").checked;
				left_cleaningMode = document.getElementById("bt_left_cleaning").checked;
		
				// Get the Color Values and do related actions	
				updateFromColor('bt_left_color_handPath', left_handPathColor);
				updateFromColor('bt_left_color_propPath', left_propPathColor);
				updateFromColor('bt_left_prop_color_filter', left_colorFilter);
		
				// Get the Sliders Values and do related actions
				updateFromSlider('bt_left_axisInitdx');
				updateFromSlider('bt_left_axisInitdy');
				updateFromSlider('bt_left_clockSpeed');
				updateFromSlider('bt_left_armLength');
				updateFromSlider('bt_left_propLength');		
			}, 0);
		}
		
		
		function getParameters() {
			getParameters_right();
			getParameters_left();
			
			setTimeout(function () {
				clockSpeedRatio=document.getElementById("bt_clockSpeedRatio").value;
				setClockSpeedRatio = document.getElementById("bt_setClockSpeedRatio").checked;
				cleaningMode = document.getElementById("bt_cleaning").checked;
				GIFGrain=document.getElementById("bt_GIFGrain").value;
				updateFromSlider('bt_speed');
				updateFromSlider('bt_scale');
				updateFromColor('bt_color_background', backgroundColor);
			}, 0);
		}
		
			
		function setParameters_right() {
			right_handPathClock = right_handPathStart;
		
			setTimeout(function () {
				document.getElementById("bt_right_propChoice").value = right_propChoice;
				document.getElementById("bt_right_armWay").value = right_armWay;
				document.getElementById("bt_right_ratio").value = right_ratio;
				document.getElementById("bt_right_nbloops").value = right_nbloops;
				document.getElementById("bt_right_armAngle").value = right_armAngle;
				document.getElementById("bt_right_propAngle").value = right_propAngle;
				document.getElementById("bt_right_propPathViewMode").value = right_propPathViewMode;
				document.getElementById("bt_right_handPathViewMode").value = right_handPathViewMode;
				document.getElementById("bt_right_prop_setColorFilter").checked = right_setColorFilter;
				document.getElementById("bt_right_shadow").checked = right_shadowMode;
				document.getElementById("bt_right_bluring").checked = right_bluringMode;
				document.getElementById("bt_right_showAxis").checked = right_showAxis;
				document.getElementById("bt_right_cleaning").checked = right_cleaningMode;
		
				// Update the Colorization Panel		
				_root.bt_right_color_propPath.shape_1.graphics._fill.style = right_propPathColor;
				_root.bt_right_color_handPath.shape_1.graphics._fill.style = right_handPathColor;
				_root.bt_right_prop_color_filter.shape_1.graphics._fill.style = right_colorFilter;
		
				// Update the Sliders Panel
				_root.bt_right_axisInitdx.setSlider(right_axisInitdx);
				_root.bt_right_axisInitdy.setSlider(right_axisInitdy);
				_root.bt_right_clockSpeed.setSlider(right_clockSpeed);
				_root.bt_right_armLength.setSlider(right_armLength);
				_root.bt_right_propLength.setSlider(right_propLength);			
			}, 0);
		
			// Do Related Actions	
			var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
			var col_s = col.split(",");
			right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			//right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
			update_right_shadow();
			update_right_bluring();
			drawAxis_right();
		}
		
		
		function setParameters_left() {
			left_handPathClock = left_handPathStart;
		
			setTimeout(function () {
				document.getElementById("bt_left_propChoice").value = left_propChoice;
				document.getElementById("bt_left_armWay").value = left_armWay;
				document.getElementById("bt_left_ratio").value = left_ratio;
				document.getElementById("bt_left_nbloops").value = left_nbloops;
				document.getElementById("bt_left_armAngle").value = left_armAngle;
				document.getElementById("bt_left_propAngle").value = left_propAngle;
				document.getElementById("bt_left_propPathViewMode").value = left_propPathViewMode;
				document.getElementById("bt_left_handPathViewMode").value = left_handPathViewMode;
				document.getElementById("bt_left_prop_setColorFilter").checked = left_setColorFilter;
				document.getElementById("bt_left_shadow").checked = left_shadowMode;
				document.getElementById("bt_left_bluring").checked = left_bluringMode;
				document.getElementById("bt_left_showAxis").checked = left_showAxis;
				document.getElementById("bt_left_cleaning").checked = left_cleaningMode;
		
				// Update the Colorization Panel				
				_root.bt_left_color_propPath.shape_1.graphics._fill.style = left_propPathColor;
				_root.bt_left_color_handPath.shape_1.graphics._fill.style = left_handPathColor;
				_root.bt_left_prop_color_filter.shape_1.graphics._fill.style = left_colorFilter;
		
				// Update the Sliders Panel
				_root.bt_left_axisInitdx.setSlider(left_axisInitdx);
				_root.bt_left_axisInitdy.setSlider(left_axisInitdy);
				_root.bt_left_clockSpeed.setSlider(left_clockSpeed);
				_root.bt_left_armLength.setSlider(left_armLength);
				_root.bt_left_propLength.setSlider(left_propLength);
		
			}, 0);
		
		
			// Do Related Action	
			var col = left_colorFilter.substring(5, left_colorFilter.length - 1);
			var col_s = col.split(",");
			left_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);		
			//left_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
			left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
			left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
			update_left_shadow();
			update_left_bluring();
			drawAxis_left();
		}
		
		
		function setParameters() {
		
			setParameters_right();
			setParameters_left();
		
			setTimeout(function () {
				_root.bt_color_background.shape_1.graphics._fill.style = backgroundColor;			
				_root.bt_speed.setSlider(animSpeedValue);
				_root.bt_scale.setSlider(scaling);
				document.getElementById("bt_GIFGrain").value = GIFGrain;
				document.getElementById("bt_clockSpeedRatio").value = clockSpeedRatio;		
				document.getElementById("bt_setClockSpeedRatio").checked = setClockSpeedRatio;
				document.getElementById("bt_cleaning").checked = cleaningMode;
			}, 0);
			
			canvas.style.backgroundColor = backgroundColor;
			update_scaling(scaling);
			
			if(setClockSpeedRatio == true)
			{	
				_root.bt_left_clockSpeed.SliderBar.shape.graphics._fill.style = "rgba(226,0,0,1)";			
				setTimeout(function () { 		
					_root.bt_left_clockSpeed.enable(false);	
					left_clockSpeed = right_clockSpeed * clockSpeedRatio;
					_root.bt_left_clockSpeed.setSlider(right_clockSpeed);
				}, 0);
			}
			else
			{			
				_root.bt_left_clockSpeed.SliderBar.shape.graphics._fill.style = "rgba(204,204,204,1)";	
				setTimeout(function () {
					_root.bt_left_clockSpeed.enable(true);	
				}, 0);
			}		
		
			if (RandomSceneMode==true) {
				_root.infoMode.text = "RANDOM MODE\n";
			} else {
				_root.infoMode.text = "";
			}
		
			createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;
			canvas.style.backgroundColor = backgroundColor;
		}
		
		
		function stop() {
			if (animRunning == true) {
				createjs.Ticker.off("tick", animTimer);
				if(cleaningMode == true)
				{
					clean();
				}
				_root.infoMode.text = "";
				animRunning = false;
			}	
		}
		
		
		function pause() {
			pauseMode = !pauseMode;
			createjs.Ticker.paused = pauseMode;
		}
		
		
		function drawAxis_right() {
			// Draw Axis 
			right_axisShape.graphics.clear();
			right_axisShape.graphics.setStrokeStyle(2).beginStroke(axisColor);
			right_axisShape.graphics.moveTo(-right_armLength - right_propLength - 5 + right_axisInitdx, 0 + right_axisInitdy);
			right_axisShape.graphics.lineTo(+right_armLength + right_propLength + 5 + right_axisInitdx, 0 + right_axisInitdy);
			right_axisShape.graphics.moveTo(0 + right_axisInitdx, -right_armLength - right_propLength - 5 + right_axisInitdy);
			right_axisShape.graphics.lineTo(0 + right_axisInitdx, +right_armLength + right_propLength + 5 + right_axisInitdy);
			right_axisShape.visible = right_showAxis;
		}
		
		
		function drawAxis_left() {
			// Draw Axis 
			left_axisShape.graphics.clear();
			left_axisShape.graphics.setStrokeStyle(2).beginStroke(axisColor);
			left_axisShape.graphics.moveTo(-left_armLength - left_propLength - 5 + left_axisInitdx, 0 + left_axisInitdy);
			left_axisShape.graphics.lineTo(+left_armLength + left_propLength + 5 + left_axisInitdx, 0 + left_axisInitdy);
			left_axisShape.graphics.moveTo(0 + left_axisInitdx, -left_armLength - left_propLength - 5 + left_axisInitdy);
			left_axisShape.graphics.lineTo(0 + left_axisInitdx, +left_armLength + left_propLength + 5 + left_axisInitdy);
			left_axisShape.visible = left_showAxis;
		}
		
		
		function join_axis() {
			right_axisInitdx = 400;
			right_armInitdx = right_axisInitdx;
			right_propInitdx = right_axisInitdx;
			right_axisInitdy = 300;
			right_armInitdy = right_axisInitdy;
			right_propInitdy = right_axisInitdy;
			_root.bt_right_axisInitdx.setSlider(right_axisInitdx);
			_root.bt_right_axisInitdy.setSlider(right_axisInitdy);
			drawAxis_right();
		
			left_axisInitdx = 400;
			left_armInitdx = left_axisInitdx;
			left_propInitdx = left_axisInitdx;
			left_axisInitdy = 300;
			left_armInitdy = left_axisInitdy;
			left_propInitdy = left_axisInitdy;
			_root.bt_left_axisInitdx.setSlider(left_axisInitdx);
			_root.bt_left_axisInitdy.setSlider(left_axisInitdy);
			drawAxis_left();
		}
		
		
		function update_right_shadow() {
			if (right_shadowMode == true) {
				right_armShape.shadow = right_armShadow;
				right_propShape.shadow = right_propShadow;
			} else {
				right_armShape.shadow = null;
				right_propShape.shadow = null;
			}
		}
		
		
		function update_left_shadow() {
			if (left_shadowMode == true) {
				left_armShape.shadow = left_armShadow;
				left_propShape.shadow = left_propShadow;
			} else {
				left_armShape.shadow = null;
				left_propShape.shadow = null;
			}
		}
		
		function update_scaling(val) {
			right_axisShape.scaleX = val;
			right_axisShape.scaleY = val;
			right_armBitmap.scaleX = val;
			right_armBitmap.scaleY = val;
			right_propPathBitmap.scaleX = val;
			right_propPathBitmap.scaleY = val;
			right_objBitmap.scaleX = val;
			right_objBitmap.scaleY = val;
			right_objHandleShape.scaleX = val;
			right_objHandleShape.scaleY = val;
		
			left_axisShape.scaleX = val;
			left_axisShape.scaleY = val;
			left_armBitmap.scaleX = val;
			left_armBitmap.scaleY = val;
			left_propPathBitmap.scaleX = val;
			left_propPathBitmap.scaleY = val;
			left_objBitmap.scaleX = val;
			left_objBitmap.scaleY = val;
			left_objHandleShape.scaleX = val;
			left_objHandleShape.scaleY = val;
		
		}
		
		
		function update_right_bluring(val) {
			if (right_bluringMode == true) {
				/*right_armShape.filters=[right_armBlurFilter];						
					right_propShape.filters=[right_propBlurFilter];				
					right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);															
					right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));*/
				if (right_objBodyShape != null) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
			} else {
				/*right_armShape.filters=[];
					right_propShape.filters=[];
					right_armShape.uncache();
					right_propShape.uncache();*/
				if (right_objBodyShape != null) {
					right_objBodyShape.filters = [];
					right_objBodyShape.uncache();
				}
			}
		}
		
		
		function update_left_bluring(val) {
			if (left_bluringMode == true) {
				/*left_armShape.filters=[left_armBlurFilter];						
					left_propShape.filters=[left_propBlurFilter];				
					left_armShape.cache(left_armInitdx-left_armLength, left_armInitdy-left_armLength, 2*left_armLength, 2*left_armLength);															
					left_propShape.cache(left_propInitdx-left_armLength-left_propLength, left_propInitdy-left_armLength-left_propLength, 2*(left_armLength+left_propLength), 2*(left_armLength+left_propLength));*/
				if (left_objBodyShape != null) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(-left_armLength - left_propLength, -left_armLength - left_propLength, 2 * (left_armLength + left_propLength), 2 * (left_armLength + left_propLength));
				}
			} else {
				/*left_armShape.filters=[];
					left_propShape.filters=[];
					left_armShape.uncache();
					left_propShape.uncache();*/
				if (left_objBodyShape != null) {
					left_objBodyShape.filters = [];
					left_objBodyShape.uncache();
				}
			}
		}
		
		
		function exportPNG() {
			// Use no standard function however
			var filename = "JSpyro.png";
			var BitmapDataExport = new createjs.BitmapData(null, displayWidth, displayHeight, backgroundColor);
			var bitmapExport = new createjs.Bitmap(BitmapDataExport.canvas);
		
			var axisDisplay = new createjs.Container();
			var right_axisShapeClone = right_axisShape.clone(true);	
			axisDisplay.addChild(right_axisShapeClone);
			left_axisShapeClone = left_axisShape.clone(true);	
			axisDisplay.addChild(left_axisShapeClone);
			axisDisplay.filters = [];
			axisDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(axisDisplay)
			axisDisplay.removeChild(right_axisShapeClone);
			axisDisplay.removeChild(left_axisShapeClone);
			axisDisplay.uncache();
		
			var right_armBitmapDisplay = new createjs.Container();
			var right_armBitmapClone = new createjs.Bitmap(right_armBitmapData.canvas);
			right_armBitmapClone.scaleX = scaling;	
			right_armBitmapClone.scaleY = scaling;
			right_armBitmapDisplay.addChild(right_armBitmapClone);	
			right_armBitmapDisplay.filters = [];	
			right_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_armBitmapDisplay);
			right_armBitmapDisplay.removeChild(right_armBitmapClone);	
			right_armBitmapDisplay.uncache();
			
			var right_propPathBitmapDisplay = new createjs.Container();
			var right_propPathBitmapClone = new createjs.Bitmap(right_propPathBitmapData.canvas);
			right_propPathBitmapClone.scaleX = scaling;	
			right_propPathBitmapClone.scaleY = scaling;
			right_propPathBitmapDisplay.addChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.filters = [];	
			right_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_propPathBitmapDisplay);
			right_propPathBitmapDisplay.removeChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.uncache();
			
			var right_objBitmapDisplay = new createjs.Container();
			var right_objBitmapClone = new createjs.Bitmap(right_objBitmapData.canvas);
			right_objBitmapClone.scaleX = scaling;	
			right_objBitmapClone.scaleY = scaling;
			right_objBitmapDisplay.addChild(right_objBitmapClone);	
			right_objBitmapDisplay.filters = [];	
			right_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objBitmapDisplay);
			right_objBitmapDisplay.removeChild(right_objBitmapClone);	
			right_objBitmapDisplay.uncache();
		
			var right_objHandleDisplay = new createjs.Container();
			var right_objHandleShapeClone = right_objHandleShape.clone(true);
			right_objHandleDisplay.addChild(right_objHandleShapeClone);
			right_objHandleDisplay.filters = [];
			right_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objHandleDisplay);
			right_objHandleDisplay.removeChild(right_objHandleShapeClone);
			right_objHandleDisplay.uncache();
		
			var left_armBitmapDisplay = new createjs.Container();
			var left_armBitmapClone = new createjs.Bitmap(left_armBitmapData.canvas);
			left_armBitmapClone.scaleX = scaling;	
			left_armBitmapClone.scaleY = scaling;
			left_armBitmapDisplay.addChild(left_armBitmapClone);	
			left_armBitmapDisplay.filters = [];	
			left_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_armBitmapDisplay);
			left_armBitmapDisplay.removeChild(left_armBitmapClone);	
			left_armBitmapDisplay.uncache();
			
			var left_propPathBitmapDisplay = new createjs.Container();
			var left_propPathBitmapClone = new createjs.Bitmap(left_propPathBitmapData.canvas);
			left_propPathBitmapClone.scaleX = scaling;	
			left_propPathBitmapClone.scaleY = scaling;
			left_propPathBitmapDisplay.addChild(left_propPathBitmapClone);	
			left_propPathBitmapDisplay.filters = [];	
			left_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_propPathBitmapDisplay);
			left_propPathBitmapDisplay.removeChild(left_propPathBitmapClone);	
			left_propPathBitmapDisplay.uncache();
			
			var left_objBitmapDisplay = new createjs.Container();
			var left_objBitmapClone = new createjs.Bitmap(left_objBitmapData.canvas);
			left_objBitmapClone.scaleX = scaling;	
			left_objBitmapClone.scaleY = scaling;
			left_objBitmapDisplay.addChild(left_objBitmapClone);	
			left_objBitmapDisplay.filters = [];	
			left_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_objBitmapDisplay);
			left_objBitmapDisplay.removeChild(left_objBitmapClone);	
			left_objBitmapDisplay.uncache();
			
			var left_objHandleDisplay = new createjs.Container();
			var left_objHandleShapeClone = left_objHandleShape.clone(true);
			left_objHandleDisplay.addChild(left_objHandleShapeClone);
			left_objHandleDisplay.filters = [];
			left_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_objHandleDisplay);
			left_objHandleDisplay.removeChild(left_objHandleShapeClone);
			left_objHandleDisplay.uncache();
		
			BitmapDataExport.canvas.toBlob(function (blob) {
				if (window.navigator.msSaveOrOpenBlob) {
					window.navigator.msSaveBlob(blob, filename);
				} else {
					var elem = window.document.createElement('a');
					elem.href = window.URL.createObjectURL(blob);
					elem.download = filename;
					document.body.appendChild(elem);
					elem.click();
					document.body.removeChild(elem);
					// no longer need to read the blob so it's revoked
					URL.revokeObjectURL(elem.href);
				}
			});
		}
		
		
		function help_show() {
			window.open(helpURL, '_blank');
		}
		
		
		function reset() {
			if(cleaningMode == true)	
			{
				clean();	
			}
			// Set the default values for parameters		
			init();
		
			//	init_left();
			//	right_propShape.filters=[];
			//	right_armShape.filters=[];
			//	left_propShape.filters=[];
			//	left_armShape.filters=[];
			//	scenariosXML=scenariosXMLDefault;
			//	bt_loadXMLFileInput.text=loadXMLDefaultFileInput;
			//	sceneName.visible=false;
			//	XMLSceneMode=false;
		
		}
		
		
		function start() {
			
			//getParameters();
			if(pauseMode == false)
			{
				right_handPathClock = right_handPathStart;
				left_handPathClock = left_handPathStart;
				right_cur_nbloops = 0;
				left_cur_nbloops = 0;
			}
			else {
				pauseMode = false;
			}
			
			if (animRunning == true) {
				if (cleaningMode == true) {
					clean();
				}
				console.log("Anim already running : restart !");
			} else {
				animRunning = true;
				_root.infoMode.text = "";
				__start();		
			}
		}
		
		
		function __start() {
		
			right_cur_nbloops = 0;
			left_cur_nbloops = 0;
		
			right_handPathdx = right_armLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
			right_handPathdy = right_armLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
			right_propPathdx = right_handPathdx + right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
			right_propPathdy = right_handPathdy + right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
			left_handPathdx = left_armLength * Math.cos(Math.PI / 2 - left_armAngleFromTime(left_handPathClock));
			left_handPathdy = left_armLength * Math.sin(Math.PI / 2 - left_armAngleFromTime(left_handPathClock));
			left_propPathdx = left_handPathdx + left_propLength * Math.cos(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
			left_propPathdy = left_handPathdy + left_propLength * Math.sin(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
		
			if (cleaningMode == true) {
				right_armShape.graphics.clear();
				right_propShape.graphics.clear();
				right_objHandleShape.graphics.clear();
				
				left_armShape.graphics.clear();
				left_propShape.graphics.clear();
				left_objHandleShape.graphics.clear();		
			}
			/*
			if(right_bluringMode == true) {					
				right_armShape.filters=[right_armBlurFilter];						
				right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);												
				right_propShape.filters=[right_propBlurFilter];	
				right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));																
			}
			else
			{	
				right_armShape.filters=[];
				right_propShape.filters=[];		
				right_armShape.uncache();
				right_propShape.uncache();
			*/
			/*
			if(left_bluringMode == true) {					
				left_armShape.filters=[left_armBlurFilter];						
				left_armShape.cache(left_armInitdx-left_armLength, left_armInitdy-left_armLength, 2*left_armLength, 2*leIFft_armLength);												
				left_propShape.filters=[left_propBlurFilter];	
				left_propShape.cache(left_propInitdx-left_armLength-left_propLength, left_propInitdy-left_armLength-left_propLength, 2*(left_armLength+left_propLength), 2*(left_armLength+left_propLength));																
			}
			else
			{	
				left_armShape.filters=[];
				left_propShape.filters=[];		
				left_armShape.uncache();
				left_propShape.uncache();
			*/
			if (right_objBodyShape != null) {
				right_objBodyShape.filters = [];
				right_objBodyShape.uncache();
			}
			if (left_objBodyShape != null) {
				left_objBodyShape.filters = [];
				left_objBodyShape.uncache();
			}
		
			if (right_shadowMode == true) {
				right_armShape.shadow = right_armShadow;
				right_propShape.shadow = right_propShadow;
			}
			if (left_shadowMode == true) {
				left_armShape.shadow = left_armShadow;
				left_propShape.shadow = left_propShadow;
			}
		
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_armShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_propShape.graphics.moveTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
			left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
			left_armShape.graphics.moveTo(left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
			left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
			left_propShape.graphics.moveTo(left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
			left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
		
			animTimer = createjs.Ticker.on("tick", run);
			createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;	
			run();
		}
		
		
		function run(evt) {
			if (XMLSceneMode == true){
				if(XMLAnimationNbloops == 0)
				{					
					stop();
					return;
				}
				else if(XMLScenarioNbloops == 0)
				{
					stop();
					if(XMLAnimationNbloops == -1 || cur_XMLAnimationNbloops < XMLAnimationNbloops)
					{
						readXML();					
					}
					return;
				}
			}
			
			if (right_nbloops != -1 && right_cur_nbloops >= right_nbloops && left_nbloops != -1 && left_cur_nbloops >= left_nbloops) {
				stop();
		
				if (XMLSceneMode == true) {	
					if(XMLAnimationNbloops == -1 || cur_XMLAnimationNbloops < XMLAnimationNbloops)
					{							
						readXML();
					}
				} else if (RandomSceneMode == true) {				
						random_anim();
				}
				return;
		
			} else if (pauseMode == true) {
				return;
			}
		
			if (right_nbloops == -1 || right_cur_nbloops < right_nbloops) {
				if (right_shadowMode == true) {
					right_armShape.shadow = right_armShadow;
					right_propShape.shadow = right_propShadow;
				}
		
				var right_handPathdxOld;
				var right_handPathdyOld;
				right_handPathdxOld = right_handPathdx;
				right_handPathdyOld = right_handPathdy;
				right_handPathdx = right_armLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
				right_handPathdy = right_armLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
		
				if (right_handPathViewMode != 0) {
					if (right_handPathViewMode == 1) {
						// Comet Mode		
						right_armShape.graphics.clear();
						right_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
						right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
					}
		
					if (right_armWay == "in") {
						right_armShape.graphics.moveTo(right_handPathdxOld + right_armInitdx, -right_handPathdyOld + right_armInitdy);
						right_armShape.graphics.lineTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					} else {
						right_armShape.graphics.moveTo(-right_handPathdxOld + right_armInitdx, -right_handPathdyOld + right_armInitdy);
						right_armShape.graphics.lineTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					}
		
					/*if (right_bluringMode==true) {	
					// Update Cache 
					right_armShape.filters=[right_armBlurFilter];						
					right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);		
				}*/
		
					right_armDisplay.filters = [];
					right_armDisplay.cache(0, 0, displayWidth, displayHeight);
					right_armBitmapData.draw(right_armDisplay);
					/*if (right_bluringMode==true) {
					if(right_setColorFilter == true)
					{
						right_armBitmapData.colorTransform(right_armBitmapData.rect, right_armColorFilter);
					}		
				}*/
				}
		
				var right_propPathdxOld;
				var right_propPathdyOld;
				right_propPathdxOld = right_propPathdx;
				right_propPathdyOld = right_propPathdy;
				right_propPathdx = right_handPathdx + right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
				right_propPathdy = right_handPathdy + right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
		
				if (right_propPathViewMode != 0) {
					if (right_propPathViewMode == 1 && right_propChoice == 0) {
						// Comet Mode only with no object		
						right_propShape.graphics.clear();
						right_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
						right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
					}
		
					// Draw Prop only if No object or Prop Path is 'Path' or 'Path+CometProp' or 'Path+Prop'
					if (right_propChoice == 0 || right_propPathViewMode == 2 || right_propPathViewMode == 4 || right_propPathViewMode == 5) {
						if (right_armWay == "in") {
							right_propShape.graphics.moveTo(right_propPathdxOld + right_propInitdx, -right_propPathdyOld + right_propInitdy);
							right_propShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
						} else {
							right_propShape.graphics.moveTo(-right_propPathdxOld + right_propInitdx, -right_propPathdyOld + right_propInitdy);
							right_propShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
						}
		
						/*if (right_bluringMode==true) {
						// Update Cache			
						right_propShape.filters=[right_propBlurFilter];	
						right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));																															
					}*/
		
						right_propPathDisplay.filters = [];
						right_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
						right_propPathBitmapData.draw(right_propPathDisplay);
						/*if (right_bluringMode==true) {
						if(right_setColorFilter == true)
						{		
							right_propPathBitmapData.colorTransform(right_propPathBitmapData.rect, right_propColorFilter);
						}
					}*/
					}
				}
		
				if (right_propPathViewMode != 0 && right_propPathViewMode != 2) {
					drawright_propObj();
				}
		
				if (right_handPathClock >= right_handPathEnd) {
					right_handPathClock = right_handPathStart;
					right_cur_nbloops++;
					if (right_cleaningMode == true) {
						clean_right();
					} else {
						//right_armShape.graphics.clear();
						//			//right_propShape.graphics.clear();
						//				if (right_shadowMode==true) {	
						//	}
		
						//right_objHandleShape.graphics.clear();
						right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
						right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
						right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
					}
				} else {
					right_handPathClock += right_clockSpeed;
				}
			}
		
			if (left_nbloops == -1 || left_cur_nbloops < left_nbloops) {
		
				if (left_shadowMode == true) {
					left_armShape.shadow = left_armShadow;
					left_propShape.shadow = left_propShadow;
				}
		
		
				var left_handPathdxOld;
				var left_handPathdyOld;
				left_handPathdxOld = left_handPathdx;
				left_handPathdyOld = left_handPathdy;
				left_handPathdx = left_armLength * Math.cos(Math.PI / 2 - left_armAngleFromTime(left_handPathClock));
				left_handPathdy = left_armLength * Math.sin(Math.PI / 2 - left_armAngleFromTime(left_handPathClock));
		
				if (left_handPathViewMode != 0) {
					if (left_handPathViewMode == 1) {
						// Comet Mode		
						left_armShape.graphics.clear();
						left_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
						left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
					}
		
					if (left_armWay == "out") {
						left_armShape.graphics.moveTo(left_handPathdxOld + left_armInitdx, -left_handPathdyOld + left_armInitdy);
						left_armShape.graphics.lineTo(left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					} else {
						left_armShape.graphics.moveTo(-left_handPathdxOld + left_armInitdx, -left_handPathdyOld + left_armInitdy);
						left_armShape.graphics.lineTo(-left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					}
		
					/*if (left_bluringMode==true) {	
					// Update Cache 
					left_armShape.filters=[left_armBlurFilter];						
					left_armShape.cache(left_armInitdx-left_armLength, left_armInitdy-left_armLength, 2*left_armLength, 2*left_armLength);		
				}*/
		
					left_armDisplay.filters = [];
					left_armDisplay.cache(0, 0, displayWidth, displayHeight);
					left_armBitmapData.draw(left_armDisplay);
					/*if (left_bluringMode==true) {
					if(left_setColorFilter == true)
					{
						left_armBitmapData.colorTransform(left_armBitmapData.rect, left_armColorFilter);
					}		
				}*/
				}
		
				var left_propPathdxOld;
				var left_propPathdyOld;
				left_propPathdxOld = left_propPathdx;
				left_propPathdyOld = left_propPathdy;
				left_propPathdx = left_handPathdx + left_propLength * Math.cos(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
				left_propPathdy = left_handPathdy + left_propLength * Math.sin(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
		
				if (left_propPathViewMode != 0) {
					if (left_propPathViewMode == 1 && left_propChoice == 0) {
						// Comet Mode only with no object		
						left_propShape.graphics.clear();
						left_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
						left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
					}
		
					// Draw Prop only if No object or Prop Path is 'Path' or 'Path+CometProp' or 'Path+Prop'
					if (left_propChoice == 0 || left_propPathViewMode == 2 || left_propPathViewMode == 4 || left_propPathViewMode == 5) {
						if (left_armWay == "out") {
							left_propShape.graphics.moveTo(left_propPathdxOld + left_propInitdx, -left_propPathdyOld + left_propInitdy);
							left_propShape.graphics.lineTo(left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
						} else {
							left_propShape.graphics.moveTo(-left_propPathdxOld + left_propInitdx, -left_propPathdyOld + left_propInitdy);
							left_propShape.graphics.lineTo(-left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
						}
		
						/*if (left_bluringMode==true) {
						// Update Cache			
						left_propShape.filters=[left_propBlurFilter];	
						left_propShape.cache(left_propInitdx-left_armLength-left_propLength, left_propInitdy-left_armLength-left_propLength, 2*(left_armLength+left_propLength), 2*(left_armLength+left_propLength));																															
					}*/
		
						left_propPathDisplay.filters = [];
						left_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
						left_propPathBitmapData.draw(left_propPathDisplay);
						/*if (left_bluringMode==true) {
						if(left_setColorFilter == true)
						{		
							left_propPathBitmapData.colorTransform(left_propPathBitmapData.rect, left_propColorFilter);
						}
					}*/
					}
				}
		
				if (left_propPathViewMode != 0 && left_propPathViewMode != 2) {
					drawleft_propObj();
				}
		
				if (left_handPathClock >= left_handPathEnd) {
					left_handPathClock = left_handPathStart;
					left_cur_nbloops++;
					if (left_cleaningMode == true) {
						clean_left();
					} else {
						//left_armShape.graphics.clear();
						//			//left_propShape.graphics.clear();
						//				if (left_shadowMode==true) {	
						//	}
		
						//left_objHandleShape.graphics.clear();
						left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
						left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
						left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
					}
				} else {
					left_handPathClock += left_clockSpeed;
				}
			}
			
			if(GIFEncoding == true)
			{
				if(GIFGrainCpt ==0)
				{   			
					GIFEncoder.addFrame(drawGIFCanvas(canvas), {delay: GIFFrameDelay});	
					GIFCpt++;
				}
				GIFGrainCpt = (GIFGrainCpt+1)%GIFGrain;		
			}
				
			// stage.update(evt);
		}
		
		
		function cloneCanvas(oldCanvas) {
		
		    //create a new canvas
		    var newCanvas = document.createElement('canvas');
		   	var context = newCanvas.getContext('2d');
		    newCanvas.width = GIFWidth;
		    newCanvas.height = GIFHeight;	
			context.fillStyle = backgroundColor;
		    context.fillRect(0, 0, GIFWidth, GIFHeight);
			
		    context.drawImage(oldCanvas,0,0,displayWidth,displayHeight,0,0,GIFWidth,GIFHeight);	
		    return newCanvas;
		}
		
		
		function drawGIFCanvas(oldCanvas) {
			var BitmapDataExport = new createjs.BitmapData(null, displayWidth, displayHeight, backgroundColor);
			var bitmapExport = new createjs.Bitmap(BitmapDataExport.canvas);
		
			var axisDisplay = new createjs.Container();
			var right_axisShapeClone = right_axisShape.clone(true);
			axisDisplay.addChild(right_axisShapeClone);
			var left_axisShapeClone = left_axisShape.clone(true);
			axisDisplay.addChild(left_axisShapeClone);
			axisDisplay.filters = [];
			axisDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(axisDisplay)
			axisDisplay.removeChild(right_axisShapeClone);
			axisDisplay.removeChild(left_axisShapeClone);
			axisDisplay.uncache();
		
			var right_armBitmapDisplay = new createjs.Container();
			var right_armBitmapClone = new createjs.Bitmap(right_armBitmapData.canvas);
			right_armBitmapClone.scaleX = scaling;	
			right_armBitmapClone.scaleY = scaling;
			right_armBitmapDisplay.addChild(right_armBitmapClone);	
			right_armBitmapDisplay.filters = [];	
			right_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_armBitmapDisplay);
			right_armBitmapDisplay.removeChild(right_armBitmapClone);	
			right_armBitmapDisplay.uncache();
			
			var right_propPathBitmapDisplay = new createjs.Container();
			var right_propPathBitmapClone = new createjs.Bitmap(right_propPathBitmapData.canvas);
			right_propPathBitmapClone.scaleX = scaling;	
			right_propPathBitmapClone.scaleY = scaling;
			right_propPathBitmapDisplay.addChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.filters = [];	
			right_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_propPathBitmapDisplay);
			right_propPathBitmapDisplay.removeChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.uncache();
			
			var right_objBitmapDisplay = new createjs.Container();
			var right_objBitmapClone = new createjs.Bitmap(right_objBitmapData.canvas);
			right_objBitmapClone.scaleX = scaling;	
			right_objBitmapClone.scaleY = scaling;
			right_objBitmapDisplay.addChild(right_objBitmapClone);	
			right_objBitmapDisplay.filters = [];	
			right_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objBitmapDisplay);
			right_objBitmapDisplay.removeChild(right_objBitmapClone);	
			right_objBitmapDisplay.uncache();
			
			var right_objHandleDisplay = new createjs.Container();
			var right_objHandleShapeClone = right_objHandleShape.clone(true);
			right_objHandleDisplay.addChild(right_objHandleShapeClone);
			right_objHandleDisplay.filters = [];
			right_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objHandleDisplay);
			right_objHandleDisplay.removeChild(right_objHandleShapeClone);
			right_objHandleDisplay.uncache();
		
			var left_armBitmapDisplay = new createjs.Container();
			var left_armBitmapClone = new createjs.Bitmap(left_armBitmapData.canvas);
			left_armBitmapClone.scaleX = scaling;	
			left_armBitmapClone.scaleY = scaling;
			left_armBitmapDisplay.addChild(left_armBitmapClone);	
			left_armBitmapDisplay.filters = [];	
			left_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_armBitmapDisplay);
			left_armBitmapDisplay.removeChild(left_armBitmapClone);	
			left_armBitmapDisplay.uncache();
			
			var left_propPathBitmapDisplay = new createjs.Container();
			var left_propPathBitmapClone = new createjs.Bitmap(left_propPathBitmapData.canvas);
			left_propPathBitmapClone.scaleX = scaling;	
			left_propPathBitmapClone.scaleY = scaling;
			left_propPathBitmapDisplay.addChild(left_propPathBitmapClone);	
			left_propPathBitmapDisplay.filters = [];	
			left_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_propPathBitmapDisplay);
			left_propPathBitmapDisplay.removeChild(left_propPathBitmapClone);	
			left_propPathBitmapDisplay.uncache();
			
			var left_objBitmapDisplay = new createjs.Container();
			var left_objBitmapClone = new createjs.Bitmap(left_objBitmapData.canvas);
			left_objBitmapClone.scaleX = scaling;	
			left_objBitmapClone.scaleY = scaling;
			left_objBitmapDisplay.addChild(left_objBitmapClone);	
			left_objBitmapDisplay.filters = [];	
			left_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_objBitmapDisplay);
			left_objBitmapDisplay.removeChild(left_objBitmapClone);	
			left_objBitmapDisplay.uncache();
			
			var left_objHandleDisplay = new createjs.Container();
			var left_objHandleShapeClone = left_objHandleShape.clone(true);
			left_objHandleDisplay.addChild(left_objHandleShapeClone);
			left_objHandleDisplay.filters = [];
			left_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(left_objHandleDisplay);
			left_objHandleDisplay.removeChild(left_objHandleShapeClone);
			left_objHandleDisplay.uncache();
			
			return cloneCanvas(BitmapDataExport.canvas);
		}
		
		
		function drawright_propObj() {
			//	0: None
			//	1: Stick
			//	2: Staff
			//	3: Poi
			//	4: Club
			//	5: Hoop
		
			if (right_propChoice == 0) {
				right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
				right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			} else if (right_propChoice == 1) {
				// Draw Stick				
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(right_propPathdx + right_propInitdx, 0);
					right_objBodyShape.graphics.lineTo(right_handPathdx + right_propInitdx - right_armInitdx, -right_handPathdy + right_propInitdy - right_armInitdy);
				} else {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.graphics.lineTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(right_propInitdx - (right_armLength + right_propLength), right_propInitdy - (right_armLength + right_propLength), 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;		
				}
			} else if (right_propChoice == 2) {
				// Draw Staff
				right_propPathdxStart = right_handPathdx - right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
				right_propPathdyStart = right_handPathdy - right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(right_propPathdxStart + right_propInitdx, -right_propPathdyStart + right_propInitdy);
					right_objBodyShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
				} else {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(-right_propPathdxStart + right_propInitdx, -right_propPathdyStart + right_propInitdy);
					right_objBodyShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(right_propInitdx - (right_armLength + right_propLength), right_propInitdy - (right_armLength + right_propLength), 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {			
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;			
				}
			} else if (right_propChoice == 3) {
				// Draw Poi 
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_poiStringSize).beginStroke(right_objHandleColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objHandleShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_poiRadius, -right_poiRadius, 2 * right_poiRadius, 2 * right_poiRadius);
					right_objBodyShape.graphics.endFill();
				} else {
					right_objHandleShape.graphics.moveTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_poiRadius, -right_poiRadius, 2 * right_poiRadius, 2 * right_poiRadius);
					right_objBodyShape.graphics.endFill();
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;					
				}
			} else if (right_propChoice == 4) {
				// Draw Club
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objHandleShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_propLength / 7, -right_propLength, right_propLength * 2 / 7, right_propLength);
					right_objBodyShape.rotation = 180 * right_propAngleFromTime(right_handPathClock) / Math.PI + 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
					right_objBodyShape.graphics.endFill();
				} else {
					right_objHandleShape.graphics.moveTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_propLength / 7, -right_propLength, right_propLength * 2 / 7, right_propLength);
					right_objBodyShape.rotation = -180 * right_propAngleFromTime(right_handPathClock) / Math.PI - 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
					right_objBodyShape.graphics.endFill();
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];		
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{							
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;
				}
			} else if (right_propChoice == 5) {
				// Draw hoop
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
				}
		
				right_objBodyShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
				right_objHandleShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "out") {
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.drawEllipse(-right_propLength, -right_propLength, right_propLength * 2, right_propLength * 2);
					right_objBodyShape.rotation = 180 * right_propAngleFromTime(right_handPathClock) / Math.PI + 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
				} else {
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.drawEllipse(-right_propLength, -right_propLength, right_propLength * 2, right_propLength * 2);
					right_objBodyShape.rotation = -180 * right_propAngleFromTime(right_handPathClock) / Math.PI - 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true){
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);			
					}	
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;		
				}
			}
		}
		
		
		function drawleft_propObj() {
			//	//0: None
			//	//1: Stick
			//	//2: Staff
			//	//3: Poi
			//	//4: Club
			//	//5: Hoop
		
			if (left_propChoice == 0) {
				left_armShape.graphics.setStrokeStyle(left_handPathSize).beginStroke(left_handPathColor);
				left_propShape.graphics.setStrokeStyle(left_propPathSize).beginStroke(left_propPathColor);
			} else if (left_propChoice == 1) {
				// Draw Stick				
				if (left_objBodyShape == null) {
					left_objBodyShape = new createjs.Shape();
					left_objDisplay.addChild(left_objBodyShape);
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				}
		
				left_objBodyShape.graphics.clear();
				left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				left_objHandleShape.graphics.clear();
		
				if (left_propPathViewMode == 1 || left_propPathViewMode == 4) {
					left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (left_armWay == "out") {
					left_objBodyShape.x = left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
					left_objBodyShape.graphics.moveTo(left_propPathdx + left_propInitdx, 0);
					left_objBodyShape.graphics.lineTo(left_handPathdx + left_propInitdx - left_armInitdx, -left_handPathdy + left_propInitdy - left_armInitdy);
				} else {
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
					left_objBodyShape.graphics.moveTo(-left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
					left_objBodyShape.graphics.lineTo(-left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
				}
		
				if (left_bluringMode == true) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(left_propInitdx - (left_armLength + left_propLength), left_propInitdy - (left_armLength + left_propLength), 2 * (left_armLength + left_propLength), 2 * (left_armLength + left_propLength));
				}
				left_objDisplay.filters = [];
				left_objDisplay.cache(0, 0, displayWidth, displayHeight);
				left_objBitmapData.draw(left_objDisplay);
				if (left_setColorFilter == true) {
					if(CptColorTransform_left == 0)
					{
						left_objBitmapData.colorTransform(left_objBitmapData.rect, left_propColorFilter);
					}	
					CptColorTransform_left = (CptColorTransform_left+1)%NbColorTransform;						
				}
			} else if (left_propChoice == 2) {
				// Draw Staff
				left_propPathdxStart = left_handPathdx - left_propLength * Math.cos(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
				left_propPathdyStart = left_handPathdy - left_propLength * Math.sin(Math.PI / 2 - left_armAngleFromTime(left_handPathClock) - left_propAngleFromTime(left_handPathClock));
				if (left_objBodyShape == null) {
					left_objBodyShape = new createjs.Shape();
					left_objDisplay.addChild(left_objBodyShape);
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				}
		
				left_objBodyShape.graphics.clear();
				left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				left_objHandleShape.graphics.clear();
		
				if (left_propPathViewMode == 1 || left_propPathViewMode == 4) {
					left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (left_armWay == "out") {
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
					left_objBodyShape.graphics.moveTo(left_propPathdxStart + left_propInitdx, -left_propPathdyStart + left_propInitdy);
					left_objBodyShape.graphics.lineTo(left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
				} else {
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
					left_objBodyShape.graphics.moveTo(-left_propPathdxStart + left_propInitdx, -left_propPathdyStart + left_propInitdy);
					left_objBodyShape.graphics.lineTo(-left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
				}
		
				if (left_bluringMode == true) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(left_propInitdx - (left_armLength + left_propLength), left_propInitdy - (left_armLength + left_propLength), 2 * (left_armLength + left_propLength), 2 * (left_armLength + left_propLength));
				}
				left_objDisplay.filters = [];
				left_objDisplay.cache(0, 0, displayWidth, displayHeight);
				left_objBitmapData.draw(left_objDisplay);
				if (left_setColorFilter == true) {
					if(CptColorTransform_left == 0)
					{
						left_objBitmapData.colorTransform(left_objBitmapData.rect, left_propColorFilter);
					}	
					CptColorTransform_left = (CptColorTransform_left+1)%NbColorTransform;							
				}
			} else if (left_propChoice == 3) {
				// Draw Poi 
				if (left_objBodyShape == null) {
					left_objBodyShape = new createjs.Shape();
					left_objDisplay.addChild(left_objBodyShape);
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				}
		
				left_objBodyShape.graphics.clear();
				left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
				left_objHandleShape.graphics.clear();
				left_objHandleShape.graphics.setStrokeStyle(left_poiStringSize).beginStroke(left_objHandleColor);
		
				if (left_propPathViewMode == 1 || left_propPathViewMode == 4) {
					left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (left_armWay == "out") {
					left_objHandleShape.graphics.moveTo(left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					left_objHandleShape.graphics.lineTo(left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
					left_objBodyShape.x = left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.beginFill(left_propPathColor, 5);
					left_objBodyShape.graphics.drawEllipse(-left_poiRadius, -left_poiRadius, 2 * left_poiRadius, 2 * left_poiRadius);
					left_objBodyShape.graphics.endFill();
				} else {
					left_objHandleShape.graphics.moveTo(-left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					left_objHandleShape.graphics.lineTo(-left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
					left_objBodyShape.x = -left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.beginFill(left_propPathColor, 5);
					left_objBodyShape.graphics.drawEllipse(-left_poiRadius, -left_poiRadius, 2 * left_poiRadius, 2 * left_poiRadius);
					left_objBodyShape.graphics.endFill();
				}
		
				if (left_bluringMode == true) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(-left_armLength - left_propLength, -left_armLength - left_propLength, 2 * (left_armLength + left_propLength), 2 * (left_armLength + left_propLength));
				}
				left_objDisplay.filters = [];
				left_objDisplay.cache(0, 0, displayWidth, displayHeight);
				left_objBitmapData.draw(left_objDisplay);
				if (left_setColorFilter == true) {
					if(CptColorTransform_left == 0)
					{
						left_objBitmapData.colorTransform(left_objBitmapData.rect, left_propColorFilter);
					}	
					CptColorTransform_left = (CptColorTransform_left+1)%NbColorTransform;		
				}
			} else if (left_propChoice == 4) {
				// Draw Club
				if (left_objBodyShape == null) {
					left_objBodyShape = new createjs.Shape();
					left_objDisplay.addChild(left_objBodyShape);
					left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);			
				}
		
				left_objBodyShape.graphics.clear();
				left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);		
				left_objHandleShape.graphics.clear();
				left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
		
				if (left_propPathViewMode == 1 || left_propPathViewMode == 4) {
					left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (left_armWay == "out") {
					left_objHandleShape.graphics.moveTo(left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					left_objHandleShape.graphics.lineTo(left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
					left_objBodyShape.x = left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.beginFill(left_propPathColor, 5);
					left_objBodyShape.graphics.drawEllipse(-left_propLength / 7, -left_propLength, left_propLength * 2 / 7, left_propLength);
					left_objBodyShape.rotation = 180 * left_propAngleFromTime(left_handPathClock) / Math.PI + 180 * left_armAngleFromTime(left_handPathClock) / Math.PI;
					left_objBodyShape.graphics.endFill();
				} else {
					left_objHandleShape.graphics.moveTo(-left_handPathdx + left_armInitdx, -left_handPathdy + left_armInitdy);
					left_objHandleShape.graphics.lineTo(-left_propPathdx + left_propInitdx, -left_propPathdy + left_propInitdy);
					left_objBodyShape.x = -left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.beginFill(left_propPathColor, 5);
					left_objBodyShape.graphics.drawEllipse(-left_propLength / 7, -left_propLength, left_propLength * 2 / 7, left_propLength);
					left_objBodyShape.rotation = -180 * left_propAngleFromTime(left_handPathClock) / Math.PI - 180 * left_armAngleFromTime(left_handPathClock) / Math.PI;
					left_objBodyShape.graphics.endFill();
				}
		
				if (left_bluringMode == true) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(-left_armLength -left_propLength, -left_armLength - left_propLength, 2* (left_armLength + left_propLength), 2* (left_armLength + left_propLength));
				}
				left_objDisplay.filters = [];		
				left_objDisplay.cache(0, 0, displayWidth, displayHeight);
				left_objBitmapData.draw(left_objDisplay);
				if (left_setColorFilter == true) {
					if(CptColorTransform_left == 0)
					{
						left_objBitmapData.colorTransform(left_objBitmapData.rect, left_propColorFilter);
					}	
					CptColorTransform_left = (CptColorTransform_left+1)%NbColorTransform;
				}
			} else if (left_propChoice == 5) {
				// Draw hoop
				if (left_objBodyShape == null) {
					left_objBodyShape = new createjs.Shape();
					left_objDisplay.addChild(left_objBodyShape);
				}
		
				left_objBodyShape.graphics.clear();
				left_objHandleShape.graphics.setStrokeStyle(left_objHandleSize).beginStroke(left_objHandleColor);
				left_objHandleShape.graphics.clear();
				left_objBodyShape.graphics.setStrokeStyle(left_objStrokeSize).beginStroke(left_propPathColor);
		
				if (left_propPathViewMode == 1 || left_propPathViewMode == 4) {
					left_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (left_armWay == "in") {
					left_objBodyShape.x = -left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.drawEllipse(-left_propLength, -left_propLength, left_propLength * 2, left_propLength * 2);
					left_objBodyShape.rotation = 180 * left_propAngleFromTime(left_handPathClock) / Math.PI + 180 * left_armAngleFromTime(left_handPathClock) / Math.PI;
				} else {
					left_objBodyShape.x = left_propPathdx + left_propInitdx;
					left_objBodyShape.y = -left_propPathdy + left_propInitdy;
					left_objBodyShape.graphics.drawEllipse(-left_propLength, -left_propLength, left_propLength * 2, left_propLength * 2);
					left_objBodyShape.rotation = -180 * left_propAngleFromTime(left_handPathClock) / Math.PI - 180 * left_armAngleFromTime(left_handPathClock) / Math.PI;
				}
		
				if (left_bluringMode == true) {
					left_objBodyShape.filters = [left_propBlurFilter];
					left_objBodyShape.cache(-left_armLength - left_propLength, -left_armLength - left_propLength, 2 * (left_armLength + left_propLength), 2 * (left_armLength + left_propLength));
				}
				left_objDisplay.filters = [];			
				left_objDisplay.cache(0, 0, displayWidth, displayHeight);
				left_objBitmapData.draw(left_objDisplay);
				if (left_setColorFilter == true) {
					if(CptColorTransform_left == 0)
					{
						left_objBitmapData.colorTransform(left_objBitmapData.rect, left_propColorFilter);
					}	
					CptColorTransform_left = (CptColorTransform_left+1)%NbColorTransform;		
				}
			}
		}
		
		
		function right_armAngleFromTime(t) {
			return t * Math.PI / 180 + right_armAngle * Math.PI / 180;
		}
		
		
		function left_armAngleFromTime(t) {
			return t * Math.PI / 180 + left_armAngle * Math.PI / 180;
		}
		
		
		function right_propAngleFromTime(t) {
			return right_ratio * (t * Math.PI / 180) + right_propAngle * Math.PI / 180;
		}
		
		
		function left_propAngleFromTime(t) {
			return left_ratio * (t * Math.PI / 180) + left_propAngle * Math.PI / 180;
		}
		
		
		function random_anim() {
		
			RandomSceneMode = true;
			XMLSceneMode = false;
			
			if (animRunning == true) {			
				stop();
			}
		
			if (right_cleaningMode == true) {
				clean_right();
			}
			if (left_cleaningMode == true) {
				clean_left();
			}
		
			var vtmp;
			right_handPathClock = 0;
			//right_propChoice=randomNumber(1,5);
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				right_armWay = "out";
			} else {
				right_armWay = "in";
			}
			right_ratio = randomNumber(0, 6);
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				right_ratio = -right_ratio;
			}
			right_nbloops = randomNumber(1, 3);
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				right_armAngle = 0;
			} else if (vtmp == 1) {
				right_armAngle = 90;
			} else if (vtmp == 2) {
				right_armAngle = 180;
			} else if (vtmp == 3) {
				right_armAngle = 270;
			}
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				right_propAngle = 0;
			} else if (vtmp == 1) {
				right_propAngle = 90;
			} else if (vtmp == 2) {
				right_propAngle = 180;
			} else if (vtmp == 3) {
				right_propAngle = 270;
			}
			setParameters_right();
		
			left_handPathClock = 0;
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				left_armWay = "out";
			} else {
				left_armWay = "in";
			}
			left_ratio = randomNumber(0, 6);
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				left_ratio = -left_ratio;
			}
			left_nbloops = right_nbloops;
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				left_armAngle = 0;
			} else if (vtmp == 1) {
				left_armAngle = 90;
			} else if (vtmp == 2) {
				left_armAngle = 180;
			} else if (vtmp == 3) {
				left_armAngle = 270;
			}
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				left_propAngle = 0;
			} else if (vtmp == 1) {
				left_propAngle = 90;
			} else if (vtmp == 2) {
				left_propAngle = 180;
			} else if (vtmp == 3) {
				left_propAngle = 270;
			}
			setParameters_left();
		
			pauseMode = false;
			animRunning = true;
			_root.infoMode.text = "RANDOM MODE\n";
			__start();
		}
		
		
		/** 
		 * Generates a truly "random" number
		 * @return Random Number
		 */
		function randomNumber(low = 0, high = 1) {
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
		
		
		function loadXML() {
			var input = document.createElement('input');
			input.type = 'file';
		
			input.onchange = e => {
				loadXMLFile = e.target.files[0];
				var reader = new FileReader();
				reader.readAsText(loadXMLFile, 'UTF-8');
				reader.onload = readerEvent => {
					loadXMLFileInput = readerEvent.target.result;
					loadXMLFileInput = loadXMLFileInput.replace(/^\s*[\r\n]/gm, "");
					if (animRunning == true) {
						stop();
					}
					clean();			
					XMLScenesCpt = 0;
					XMLScenariosCpt = 0;
					cur_XMLSceneNbloops = 0;
					cur_XMLScenarioNbloops = 0;
					cur_XMLAnimationNbloops = 0;
					readXML();
				}
			}
			input.click();
		}
		
		
		function runXML() {
			if (loadXMLFileInput == '') {
				alert("Load XML File before !");
				return;
			} else {		
				if (XMLSceneMode == true)
				{
					stop();
				}
				
				readXML();
			}
		}
		
		
		function readXML() {
			var xmlDoc;
			try {
				if (window.DOMParser) {
					parser = new DOMParser();
					xmlDoc = parser.parseFromString(loadXMLFileInput, "text/xml");
				} else // Internet Explorer
				{
					xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = false;
					xmlDoc.loadXML(loadXMLFileInput);
				}
			} catch (e) {
				alert(e);
				return;
			}
		
			var rootElement = xmlDoc.documentElement;
			if (rootElement.hasAttribute("name")) {
				XMLAnimationName = rootElement.getAttribute("name");
			} else {
				XMLAnimationName = "";
			}
			if (rootElement.hasAttribute("nbloops")) {
				XMLAnimationNbloops = rootElement.getAttribute("nbloops");
			} else {
				XMLAnimationNbloops = -1;
			}
			var scenariosXML = rootElement.getElementsByTagName('scenario')
			if (scenariosXML.length == 0) {
				alert("No Scenario in XML File.");
				return;
			}
		
			XMLSceneMode = true;
			RandomSceneMode = false;
			right_handPathStart = 0;
			right_handPathEnd = 360;
			left_handPathStart = 0;
			left_handPathEnd = 360;
			right_handPathClock = right_handPathStart;
			left_handPathClock = left_handPathStart;
			
			var cur_scenario = scenariosXML[XMLScenariosCpt];
			
			if (cur_scenario.hasAttribute("name")) {
				XMLScenarioName = cur_scenario.getAttribute("name");
			} else {
				XMLScenarioName = "";
			}	
		
			if (cur_scenario.hasAttribute("nbloops")) {
				XMLScenarioNbloops = cur_scenario.getAttribute("nbloops");		
			} else {
				XMLScenarioNbloops = 1;
			}
		
		
			var scenesXML = cur_scenario.getElementsByTagName('scene')
			if (scenesXML.length == 0) {
				alert("No Scene in XML File in Scenario N°"+XMLScenariosCpt+" <" + XMLScenarioName +">" );
				return;
			}
			
			var cur_scene = scenesXML[XMLScenesCpt];
			if (cur_scene.hasAttribute("name")) {
				XMLSceneName = cur_scene.getAttribute("name");
			} else {
				XMLSceneName = "";
			}
			
			if (cur_scene.hasAttribute("nbloops")) {
				XMLSceneNbloops = cur_scene.getAttribute("nbloops");		
			} else {
				XMLSceneNbloops = 1;
			}
		
			if (cur_scene.getElementsByTagName('right').length > 0) {
				var side = cur_scene.getElementsByTagName('right')[0];
				var listAttribut = side.attributes;
				for (var k = 0; k < listAttribut.length; k++) {
					var attribut = listAttribut[k];
					if (attribut.name == "propChoice") {
						right_propChoice = parseInt(attribut.value, 10);
					} else if (attribut.name == "armWay") {
						right_armWay = attribut.value;
					} else if (attribut.name == "ratio") {
						right_ratio = parseInt(attribut.value, 10);
					} else if (attribut.name == "nbloops") {
						right_nbloops = parseFloat(attribut.value);
					} else if (attribut.name == "armAngle") {
						right_armAngle = parseFloat(attribut.value);
					} else if (attribut.name == "propAngle") {
						right_propAngle = parseFloat(attribut.value);
					} else if (attribut.name == "handPathViewMode") {
						right_handPathViewMode = parseInt(attribut.value, 10);
					} else if (attribut.name == "colorHandPath") {
						right_handPathColor = attribut.value;
					} else if (attribut.name == "colorPropPath") {
						right_propPathColor = attribut.value;
					} else if (attribut.name == "propPathViewMode") {
						right_propPathViewMode = parseInt(attribut.value, 10);
					} else if (attribut.name == "colorFilter") {
						right_colorFilter = attribut.value;
					} else if (attribut.name == "setColorFilter") {
						if (attribut.value == "true") {
							right_setColorFilter = true;
						} else {
							right_setColorFilter = false;
						}
					} else if (attribut.name == "shadow") {
						if (attribut.value == "true") {
							right_shadowMode = true;
						} else {
							right_shadowMode = false;
						}
					} else if (attribut.name == "blurring") {
						if (attribut.value == "true") {
							right_bluringMode = true;
						} else {
							right_bluringMode = false;
						}
					} else if (attribut.name == "showAxis") {
						if (attribut.value == "true") {
							right_showAxis = true;
						} else {
							right_showAxis = false;
						}
					} else if (attribut.name == "cleaning") {									
						if (attribut.value == "true") {				
							right_cleaningMode = true;
						} else {							
							right_cleaningMode = false;
						}
					} else if (attribut.name == "axisDx") {
						right_axisInitdx = parseFloat(attribut.value);
						right_armInitdx = right_axisInitdx;
						right_propInitdx = right_axisInitdx;
					} else if (attribut.name == "axisDy") {
						right_axisInitdy = parseFloat(attribut.value);
						right_armInitdy = right_axisInitdy;
						right_propInitdy = right_axisInitdy;
					} else if (attribut.name == "clockSpeed") {
						right_clockSpeed = parseFloat(attribut.value);
					} else if (attribut.name == "armLength") {
						right_armLength = parseFloat(attribut.value);
					} else if (attribut.name == "propLength") {
						right_propLength = parseFloat(attribut.value);
					} 
					
					else if (attribut.name == "handPathStart") {
						right_handPathStart = parseFloat(attribut.value);
					} else if (attribut.name == "handPathEnd") {
						right_handPathEnd = parseFloat(attribut.value);
					} else if (attribut.name == "objHandleSize") {
						right_objHandleSize = parseFloat(attribut.value);
					} else if (attribut.name == "colorObjHandle") {
						right_objHandleColor = attribut.value;
					} else if (attribut.name == "propPathSize") {
						right_propPathSize = parseFloat(attribut.value);
					} else if (attribut.name == "poiStringSize") {
						right_poiStringSize = parseFloat(attribut.value);
					} else if (attribut.name == "poiRadius") {
						right_poiRadius = parseFloat(attribut.value);
					} else if (attribut.name == "handPathSize") {
						right_handPathSize = parseFloat(attribut.value);
					} else if (attribut.name == "objStrokeSize") {
						right_objStrokeSize = parseFloat(attribut.value);
					} else {
						console.log("Invalid Attribute in XML File:", attribut.name);
					}
				}
			}
		
			if (cur_scene.getElementsByTagName('left').length > 0) {
				var side = cur_scene.getElementsByTagName('left')[0];
				var listAttribut = side.attributes;
				for (var k = 0; k < listAttribut.length; k++) {
					var attribut = listAttribut[k];
					if (attribut.name == "propChoice") {
						left_propChoice = parseInt(attribut.value, 10);
					} else if (attribut.name == "armWay") {
						left_armWay = attribut.value;
					} else if (attribut.name == "ratio") {
						left_ratio = parseInt(attribut.value, 10);
					} else if (attribut.name == "nbloops") {
						left_nbloops = parseFloat(attribut.value);
					} else if (attribut.name == "armAngle") {
						left_armAngle = parseFloat(attribut.value);
					} else if (attribut.name == "propAngle") {
						left_propAngle = parseFloat(attribut.value);
					} else if (attribut.name == "handPathViewMode") {
						left_handPathViewMode = parseInt(attribut.value, 10);
					} else if (attribut.name == "colorHandPath") {
						left_handPathColor = attribut.value;
					} else if (attribut.name == "colorPropPath") {
						left_propPathColor = attribut.value;
					} else if (attribut.name == "propPathViewMode") {
						left_propPathViewMode = parseInt(attribut.value, 10);
					} else if (attribut.name == "colorFilter") {
						left_colorFilter = attribut.value;
					} else if (attribut.name == "setColorFilter") {
						if (attribut.value == "true") {
							left_setColorFilter = true;
						} else {
							left_setColorFilter = false;
						}
					} else if (attribut.name == "shadow") {
						if (attribut.value == "true") {
							left_shadowMode = true;
						} else {
							left_shadowMode = false;
						}
					} else if (attribut.name == "blurring") {
						if (attribut.value == "true") {
							left_bluringMode = true;
						} else {
							left_bluringMode = false;
						}
					} else if (attribut.name == "showAxis") {
						if (attribut.value == "true") {
							left_showAxis = true;
						} else {
							left_showAxis = false;
						}
					} else if (attribut.name == "cleaning") {
						if (attribut.value == "true") {
							left_cleaningMode = true;
						} else {
							left_cleaningMode = false;
						}
					} else if (attribut.name == "axisDx") {
						left_axisInitdx = parseFloat(attribut.value);
						left_armInitdx = left_axisInitdx;
						left_propInitdx = left_axisInitdx;
					} else if (attribut.name == "axisDy") {
						left_axisInitdy = parseFloat(attribut.value);
						left_armInitdy = left_axisInitdy;
						left_propInitdy = left_axisInitdy;
					} else if (attribut.name == "clockSpeed") {
						left_clockSpeed = parseFloat(attribut.value);
					} else if (attribut.name == "armLength") {
						left_armLength = parseFloat(attribut.value);
					} else if (attribut.name == "propLength") {
						left_propLength = parseFloat(attribut.value);
					} 
					
					else if (attribut.name == "handPathStart") {
						left_handPathStart = parseFloat(attribut.value);
					} else if (attribut.name == "handPathEnd") {
						left_handPathEnd = parseFloat(attribut.value);
					} else if (attribut.name == "objHandleSize") {
						left_objHandleSize = parseFloat(attribut.value);
					} else if (attribut.name == "colorObjHandle") {
						left_objHandleColor = attribut.value;
					} else if (attribut.name == "propPathSize") {
						left_propPathSize = parseFloat(attribut.value);
					} else if (attribut.name == "poiStringSize") {
						left_poiStringSize = parseFloat(attribut.value);
					} else if (attribut.name == "poiRadius") {
						left_poiRadius = parseFloat(attribut.value);
					} else if (attribut.name == "handPathSize") {
						left_handPathSize = parseFloat(attribut.value);
					} else if (attribut.name == "objStrokeSize") {
						left_objStrokeSize = parseFloat(attribut.value);
					} else {
						console.log("Invalid Attribute in XML File:", attribut.name);
					}
				}
			}
		
			if (cur_scene.getElementsByTagName('both').length > 0) {
				var side = cur_scene.getElementsByTagName('both')[0];
				var listAttribut = side.attributes;
				for (var k = 0; k < listAttribut.length; k++) {
					var attribut = listAttribut[k];
					if (attribut.name == "speed") {
						animSpeedValue = parseFloat(attribut.value);
					} else if (attribut.name == "scale") {
						scaling = parseFloat(attribut.value);
					} else if (attribut.name == "colorBackground") {
						backgroundColor = attribut.value;			
					} else if (attribut.name == "clockSpeedRatio") {
						clockSpeedRatio = parseFloat(attribut.value);
					} else if (attribut.name == "setClockSpeedRatio") {
						if (attribut.value == "true") {
							setClockSpeedRatio = true;
						} else {
							setClockSpeedRatio = false;
						}	
					} else if (attribut.name == "cleaning") {
						if (attribut.value == "true") {
							cleaningMode = true;
						} else {
							cleaningMode = false;
						}	
					} else if (attribut.name == "GIFQuality") {
						GIFQuality=parseInt(attribut.value, 10);
					} else if (attribut.name == "GIFWorkers") {
						GIFWorkers=parseInt(attribut.value, 10);
					} else if (attribut.name == "GIFWidth") {
						GIFWidth=parseInt(attribut.value, 10);
					} else if (attribut.name == "GIFHeight") {
						GIFHeight=parseInt(attribut.value, 10);
					} else if (attribut.name == "GIFFrameDelay") {
						GIFFrameDelay=parseFloat(attribut.value);
					} else if (attribut.name == "GIFGrain") {
						GIFGrain=parseInt(attribut.value, 10);
					} else if (attribut.name == "NbColorTransform") {
						NbColorTransform=parseInt(attribut.value, 10);
					}					
					else {
						console.log("Invalid Attribute in XML File:", attribut.name);
					}			
				}
			}
			
		
			if(XMLSceneNbloops == -1 || cur_XMLSceneNbloops < XMLSceneNbloops-1)
			{			
				cur_XMLSceneNbloops ++;		
			}
			else
			{		
				if(XMLScenesCpt >= scenesXML.length -1)
				{	
					if(XMLScenarioNbloops == -1)
					{
						cur_XMLScenarioNbloops ++;	
					} 
					else if(XMLScenarioNbloops != -1 && cur_XMLScenarioNbloops < XMLScenarioNbloops-1)			
					{
						cur_XMLScenarioNbloops ++;	
					}
					else
					{						
						cur_XMLScenarioNbloops = 0;	
						XMLScenariosCpt = (XMLScenariosCpt + 1) % (scenariosXML.length);		
						if(XMLScenariosCpt == 0)
						{							
							cur_XMLAnimationNbloops ++;						
						}
					}					
				}
				
				cur_XMLSceneNbloops =  0;		
				XMLScenesCpt = (XMLScenesCpt + 1) % (scenesXML.length);				
					
			}
			
			setParameters();	
			
			right_handPathClock = right_handPathStart;
			left_handPathClock = left_handPathStart;
			pauseMode = false;
			animRunning = true;
			_root.infoMode.text = "XML MODE\n" + XMLAnimationName + "\n" + XMLScenarioName + ":" + XMLSceneName;
			__start();
			
		}
		
		
		function exportXML() {
			filename = "configJSpyro.xml";
		
			var outXML = '';
			
			if(XMLSceneMode == true && loadXMLFileInput != '')
			{
				outXML=loadXMLFileInput;
			}
			else {
				outXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<animation name=\"AnimConfig\" nbloops=\""+XMLAnimationNbloops+"\"><scenario name=\"ScenarioConfig\" nbloops=\""+XMLScenarioNbloops+"\">\n\n<scene name=\"SceneConfig\" nbloops=\""+XMLSceneNbloops+"\">\n\n";
				outXML += "<right ";
				outXML += "axisDx=\"" + right_axisInitdx + '\" ';
				outXML += "axisDy=\"" + right_axisInitdy + '\" ';
				outXML += "propChoice=\"" + right_propChoice + '\" ';
				outXML += "handPathViewMode=\"" + right_handPathViewMode + '\" ';
				outXML += "propPathViewMode=\"" + right_propPathViewMode + '\" ';
				outXML += "armWay=\"" + right_armWay + '\" ';
				outXML += "ratio=\"" + right_ratio + '\" ';
				outXML += "nbloops=\"" + right_nbloops + '\" ';
				outXML += "armAngle=\"" + right_armAngle + '\" ';
				outXML += "propAngle=\"" + right_propAngle + '\" ';
				outXML += "clockSpeed=\"" + right_clockSpeed + '\" ';
				outXML += "armLength=\"" + right_armLength + '\" ';
				outXML += "propLength=\"" + right_propLength + '\" ';
				outXML += "colorPropPath=\"" + right_propPathColor + '\" ';
				outXML += "colorHandPath=\"" + right_handPathColor + '\" ';
				outXML += "colorFilter=\"" + right_colorFilter + '\" ';
				outXML += "setColorFilter=\"" + right_setColorFilter.toString() + '\" ';
				outXML += "shadow=\"" + right_shadowMode.toString() + '\" ';
				outXML += "blurring=\"" + right_bluringMode.toString() + '\" ';
				outXML += "showAxis=\"" + right_showAxis.toString() + '\" ';
				outXML += "cleaning=\"" + right_cleaningMode.toString() + '\" ';
		
				outXML += "objHandleSize=\"" + right_objHandleSize + '\" ';
				outXML += "colorObjHandle=\"" + right_objHandleColor + '\" ';
				outXML += "propPathSize=\"" + right_propPathSize + '\" ';
				outXML += "poiStringSize=\"" + right_poiStringSize + '\" ';
				outXML += "poiRadius=\"" + right_poiRadius + '\" ';
				outXML += "handPathSize=\"" + right_handPathSize + '\" ';
				outXML += "objStrokeSize=\"" + right_objStrokeSize + '\" ';
				outXML += "handPathStart=\"" + right_handPathStart + '\" ';
				outXML += "handPathEnd=\"" + right_handPathEnd + "\" />\n\n";
			
				outXML += "<left ";
				outXML += "axisDx=\"" + left_axisInitdx + '\" ';
				outXML += "axisDy=\"" + left_axisInitdy + '\" ';
				outXML += "propChoice=\"" + left_propChoice + '\" ';
				outXML += "handPathViewMode=\"" + left_handPathViewMode + '\" ';
				outXML += "propPathViewMode=\"" + left_propPathViewMode + '\" ';
				outXML += "armWay=\"" + left_armWay + '\" ';
				outXML += "ratio=\"" + left_ratio + '\" ';
				outXML += "nbloops=\"" + left_nbloops + '\" ';
				outXML += "armAngle=\"" + left_armAngle + '\" ';
				outXML += "propAngle=\"" + left_propAngle + '\" ';
				outXML += "clockSpeed=\"" + left_clockSpeed + '\" ';
				outXML += "armLength=\"" + left_armLength + '\" ';
				outXML += "propLength=\"" + left_propLength + '\" ';
				outXML += "colorPropPath=\"" + left_propPathColor + '\" ';
				outXML += "colorHandPath=\"" + left_handPathColor + '\" ';
				outXML += "colorFilter=\"" + left_colorFilter + '\" ';
				outXML += "setColorFilter=\"" + left_setColorFilter.toString() + '\" ';
				outXML += "shadow=\"" + left_shadowMode.toString() + '\" ';
				outXML += "blurring=\"" + left_bluringMode.toString() + '\" ';
				outXML += "showAxis=\"" + left_showAxis.toString() + '\" ';
				outXML += "cleaning=\"" + left_cleaningMode.toString() + '\" ';
		
				outXML += "objHandleSize=\"" + left_objHandleSize + '\" ';
				outXML += "colorObjHandle=\"" + left_objHandleColor + '\" ';
				outXML += "propPathSize=\"" + left_propPathSize + '\" ';
				outXML += "poiStringSize=\"" + left_poiStringSize + '\" ';
				outXML += "poiRadius=\"" + left_poiRadius + '\" ';
				outXML += "handPathSize=\"" + left_handPathSize + '\" ';
				outXML += "objStrokeSize=\"" + left_objStrokeSize + '\" ';
				outXML += "handPathStart=\"" + left_handPathStart + '\" ';
				outXML += "handPathEnd=\"" + left_handPathEnd + "\" />\n\n";
		
				outXML += "<both ";
				outXML += "speed=\"" + animSpeedValue + '\" ';
				outXML += "scale=\"" + scaling + '\" ';
				outXML += "setClockSpeedRatio=\"" + setClockSpeedRatio.toString() + '\" '; 
				outXML += "clockSpeedRatio=\"" + clockSpeedRatio + '\" '; 
				outXML += "cleaning=\"" + cleaningMode.toString() + '\" ';		
				outXML += "colorBackground=\"" + backgroundColor + '\" ';
				
				outXML += "GIFQuality=\"" + GIFQuality + '\" ';
				outXML += "GIFWorkers=\"" + GIFWorkers + '\" ';
				outXML += "GIFWidth=\"" + GIFWidth + '\" ';
				outXML += "GIFHeight=\"" + GIFHeight + '\" ';
				outXML += "GIFFrameDelay=\"" + GIFFrameDelay + '\" ';
				outXML += "GIFGrain=\"" + GIFGrain + '\" ';
				outXML += "NbColorTransform=\"" + NbColorTransform + "\" />\n\n";
				
				outXML += "</scene>\n\n</scenario>\n\n</animation>\n";
			}
			var exportXML = new Blob([outXML]);
			if (window.navigator.msSaveOrOpenBlob) {
				window.navigator.msSaveBlob(exportXML, filename);		
			} else {
				var elem = window.document.createElement('a');
				elem.href = window.URL.createObjectURL(exportXML);
				elem.download = filename;
				document.body.appendChild(elem);
				elem.click();
				document.body.removeChild(elem);
				// no longer need to read the blob so it's revoked		
				URL.revokeObjectURL(elem.href);
			}
		}
		
		
		function startGIFEncoding() {
		
			if(GIFEncoding == true)
			{
				console.log('GIF encoding already running !');
				return;
			}
			
			GIFEncoding = true;
			GIFGrainCpt = 0;
			GIFCpt = 0;
			GIFEncoder = new GIF({
				workers: GIFWorkers,
				quality: GIFQuality,
				debug: true,
				width:GIFWidth,
				height:GIFHeight,		
			});
			
			_root.infoMode2.text = "Record";
			var GIFEncoder_listener=GIFEncoder.on('finished', function(blob) {
				filenameGIF="animJSpyro.gif";
				_root.infoMode2.text = "";
				if (window.navigator.msSaveOrOpenBlob) {
					window.navigator.msSaveBlob(blob, filenameGIF);		
				} else {
					var elem = window.document.createElement('a');
					elem.href = window.URL.createObjectURL(blob);
					elem.download = filenameGIF;
					document.body.appendChild(elem);
					elem.click();
					document.body.removeChild(elem);
					// no longer need to read the blob so it's revoked		
					URL.revokeObjectURL(elem.href);
				}	
			});	
		}
		
		
		function stopGIFEncoding() {
			
			if(GIFCpt != 0)
			{
				GIFEncoder.render();
				_root.infoMode2.text = "Rendering";
			}
			else
			{
				_root.infoMode2.text = "";
			}
			GIFEncoding = false;
			GIFGrainCpt = 0;
			GIFCpt = 0;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Run timeline
		/////////////////////////////////////////////////////////////////////////////////////////
		
		init();
		build_scene();
		animRunning = true;
		if(_root.JSpyroXMLSceneMode == true)
		{
			XMLSceneMode = true;
			runXML();
		}
		else if (_root.JSpyroRandomMode == true) {	
			random_anim();
		}
		else
		{
			__start();
		}
	}
	this.frame_11 = function() {
		//############################################addChi############################
		//## juggleSpyro                                                              ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//##                                                                          ##
		//## Copyright (C) 2014-2020  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
		//##                                                                          ##
		//##                                                                          ##
		//## This program is free software; you can redistribute it and/or modify it  ##
		//## under the terms of the GNU General Public License version 3 as           ##
		//## published by the Free Software Foundation; version 3.                    ##
		//##                                                                          ##
		//## This program is distributed in the hope that it will be useful, but      ##
		//## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
		//## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
		//## General Public License for more details.                                 ##
		//##                                                                          ##
		//##############################################################################
		
		_root = this;
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Global Parameters / Variables
		/////////////////////////////////////////////////////////////////////////////////////////
		var backgroundColor = _root.JSpyroColorBackground;
		var axisColor = 'rgba(175,175,175,1)';
		var pauseMode = false;
		var displayWidth = stage.canvas.width/stage.scaleX;
		var displayHeight = stage.canvas.height/stage.scaleY;
		var animTimer;
		var animSpeedValueMax = 100;
		var animSpeedValue = _root.JSpyroSpeed;
		var animRunning = false;
		var scaling = _root.JSpyroScaling;
		var color_Selected = 'bt_color_background';
		var RandomSceneMode = false;
		var XMLSceneMode = false;
		var GIFEncoder;
		var GIFGrain = _root.JSpyroGIFGrain;
		var GIFGrainCpt = 0;
		var GIFCpt = 0;
		var GIFEncoding = false;
		var GIFQuality = _root.JSpyroGIFQuality;
		var GIFWorkers = _root.JSpyroGIFWorkers;
		var GIFWidth = _root.JSpyroGIFWidth;
		var GIFHeight = _root.JSpyroGIFHeight;
		var GIFFrameDelay = _root.JSpyroGIFFrameDelay;
		var helpURL = _root.JSpyroHelpURL;
		var cleaningMode = _root.JSpyroCleaningMode;
		
		var CptColorTransform_right= 0;
		var NbColorTransform= _root.JSpyroNbColorTransform;
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Right Parameters / Variables
		/////////////////////////////////////////////////////////////////////////////////////////
		var right_ratio = -4;
		var right_shadowMode = false;
		var right_bluringMode = true;
		var right_cleaningMode = true;
		var right_armWay = "out";
		var right_showAxis = false;
		var right_nbloops = -1;
		var right_clockSpeed = 2;
		var right_setColorFilter = false;
		var right_cur_nbloops = 0;
		
		//// Axis Parameters
		var right_axisShape = new createjs.Shape();
		var right_axisInitdx = 400;
		var right_axisInitdy = 300;
		
		//// Hand Parameters
		var right_armShape = new createjs.Shape();
		var right_armLength = 100;
		var right_handPathColor = 'rgba(0,255,0,1)';
		var right_handPathClock = 0;
		var right_handPathStart = 0;
		var right_handPathEnd = 360;
		var right_handPathdx;
		var right_handPathdy;
		var right_armInitdx = right_axisInitdx;
		var right_armInitdy = right_axisInitdy;
		var right_armAngle = 0;
		var right_handPathSize = _root.JSpyroRightHandPathSize;
		var right_handPathViewMode = 2;
		var right_armDisplay = new createjs.Container();
		var right_armBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_armBitmap = new createjs.Bitmap(right_armBitmapData.canvas);
		
		//// Prop Path Parameters
		var right_propShape = new createjs.Shape();
		var right_propLength = 50;
		var right_objStrokeSize = _root.JSpyroRightObjStrokeSize;
		var right_propPathColor = 'rgba(226,0,0,1)';
		var right_propPathdx;
		var right_propPathdy;
		var right_propInitdx = right_axisInitdx;
		var right_propInitdy = right_axisInitdy;
		var right_propAngle = 0;
		var right_propChoice = 4;
		var right_propPathSize = _root.JSpyroRightPropPathSize;
		var right_propPathViewMode = 3;
		var right_propPathDisplay = new createjs.Container();
		var right_propPathBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_propPathBitmap = new createjs.Bitmap(right_propPathBitmapData.canvas);
		
		//// Prop Object Parameters
		var right_objHandleColor = _root.JSpyroRightColorObjHandle;
		var right_objHandleShape = new createjs.Shape(); // A Basic shape used by object (ex string in poi, or club handle)
		var right_objHandleSize = _root.JSpyroRightObjHandleSize;
		var right_poiStringSize = _root.JSpyroRightPoiStringSize;
		var right_poiRadius = _root.JSpyroRightPoiRadius;
		var right_objBodyShape;
		var right_objDisplay = new createjs.Container();
		var right_objBitmapData = new createjs.BitmapData(null, displayWidth, displayHeight, 'rgba(0,0,0,0)');
		var right_objBitmap = new createjs.Bitmap(right_objBitmapData.canvas);
		
		//// Misc
		var right_armShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var right_propShadow = new createjs.Shadow('#999999', 1, 1, 0.5);
		var right_armBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var right_propBlurFilter = new createjs.BlurFilter(4, 4, 0.5);
		var right_colorFilter = 'rgba(252,242,229,1)';
		var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
		var col_s = col.split(",");
		var right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		//var right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Right Panel (On the Left)
		/////////////////////////////////////////////////////////////////////////////////////////
		
		if (!this.bt_right_propChoice_change_cbk) {
			function bt_right_propChoice_change(evt) {
				if (right_objBodyShape != null) {
					right_objDisplay.removeChild(right_objBodyShape);
					right_objBodyShape = null;
				}
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
				right_propChoice = evt.target.value;		
			}
			$("#dom_overlay_container").on("change", "#bt_right_propChoice", bt_right_propChoice_change.bind(this));
			this.bt_right_propChoice_change_cbk = true;
		}
		
		
		if (!this.bt_right_armWay_change_cbk) {
			function bt_right_armWay_change(evt) {
				right_armWay = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_armWay", bt_right_armWay_change.bind(this));
			this.bt_right_armWay_change_cbk = true;
		}
		
		
		if (!this.bt_right_propPathViewMode_cbk) {
			function bt_right_propPathViewMode_change(evt) {
				right_propPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_propPathViewMode", bt_right_propPathViewMode_change.bind(this));
			this.bt_right_propPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_right_handPathViewMode_cbk) {
			function bt_right_handPathViewMode_change(evt) {
				right_handPathViewMode = evt.target.value;
			}
			$("#dom_overlay_container").on("change", "#bt_right_handPathViewMode", bt_right_handPathViewMode_change.bind(this));
			this.bt_right_handPathViewMode_change_cbk = true;
		}
		
		
		if (!this.bt_right_ratio_change_cbk) {
			function bt_right_ratio_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_ratio = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_ratio", bt_right_ratio_change.bind(this));
			this.bt_right_ratio_change_cbk = true;
		}
		
		
		if (!this.bt_right_nbloops_change_cbk) {
			function bt_right_nbloops_change(evt) {		
				var regex = /[^0-9]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_nbloops = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_nbloops", bt_right_nbloops_change.bind(this));
			this.bt_right_nbloops_change_cbk = true;
		}
		
		
		if (!this.bt_right_armAngle_change_cbk) {
			function bt_right_armAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_armAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_armAngle", bt_right_armAngle_change.bind(this));
			this.bt_right_armAngle_change_cbk = true;
		}
		
		
		if (!this.bt_right_propAngle_change_cbk) {
			function bt_right_propAngle_change(evt) {
				// Regex is not exact however
				var regex = /[^0-9\.-]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				right_propAngle = evt.target.value;
			}
			$("#dom_overlay_container").on("keyup", "#bt_right_propAngle", bt_right_propAngle_change.bind(this));
			this.bt_right_propAngle_change_cbk = true;
		}
		
		
		if (!this.bt_right_shadow_change_cbk) {
			function bt_right_shadow_change(evt) {
				right_shadowMode = !right_shadowMode;
				update_right_shadow();
			}
			$("#dom_overlay_container").on("change", "#bt_right_shadow", bt_right_shadow_change.bind(this));
			this.bt_right_shadow_change_cbk = true;
		}
		
		
		if (!this.bt_right_bluring_change_cbk) {
			function bt_right_bluring_change(evt) {
				right_bluringMode = !right_bluringMode;
				update_right_bluring();
			}
			$("#dom_overlay_container").on("change", "#bt_right_bluring", bt_right_bluring_change.bind(this));
			this.bt_right_bluring_change_cbk = true;
		}
		
		
		if (!this.bt_right_prop_setColorFilter_change_cbk) {
			function bt_right_prop_setColorFilter_change(evt) {
				right_setColorFilter = !right_setColorFilter;
			}
			$("#dom_overlay_container").on("change", "#bt_right_prop_setColorFilter", bt_right_prop_setColorFilter_change.bind(this));
			this.bt_right_prop_setColorFilter_change_cbk = true;
		}
		
		
		if (!this.bt_right_showAxis_change_cbk) {
			function bt_right_showAxis_change(evt) {
				right_showAxis = !right_showAxis;
				right_axisShape.visible = right_showAxis;		
			}
			$("#dom_overlay_container").on("change", "#bt_right_showAxis", bt_right_showAxis_change.bind(this));
			this.bt_right_showAxis_change_cbk = true;
		}
		
		
		if (!this.bt_right_cleaning_change_cbk) {
			function bt_right_cleaning_change(evt) {
				right_cleaningMode = !right_cleaningMode;
			}
			$("#dom_overlay_container").on("change", "#bt_right_cleaning", bt_right_cleaning_change.bind(this));
			this.bt_right_cleaning_change_cbk = true;
		}
		
		
		if (!this.bt_slider_change_cbk) {
			bt_slider_listener=this.on('bt_slider', function (evt) {
				var slider_selected = evt.initiator;
				updateFromSlider(slider_selected);
			});
			this.bt_slider_change_cbk = true;
		}
		
		
		function updateFromSlider(slider) {
			// Get the Value and update slider according to it 	
			if (slider == 'bt_right_axisInitdx') {
				right_axisInitdx = _root.bt_right_axisInitdx.getValue();
				drawAxis_right();
				right_armInitdx = right_axisInitdx;
				right_propInitdx = right_axisInitdx;
			} else if (slider == 'bt_right_axisInitdy') {
				right_axisInitdy = _root.bt_right_axisInitdy.getValue();
				drawAxis_right();
				right_armInitdy = right_axisInitdy;
				right_propInitdy = right_axisInitdy;
			} else if (slider == 'bt_right_armLength') {
				right_armLength = _root.bt_right_armLength.getValue();
			} else if (slider == 'bt_right_propLength') {
				right_propLength = _root.bt_right_propLength.getValue();
			} else if (slider == 'bt_right_clockSpeed') {
				right_clockSpeed = _root.bt_right_clockSpeed.getValue();
			} else if (slider == 'bt_speed') {
				animSpeedValue = _root.bt_speed.getValue();
				createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;
			} else if (slider == 'bt_scale') {
				scaling = _root.bt_scale.getValue();
				update_scaling(scaling);
			}
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Bottom Panel 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		
		if (!this.colorSelectShow_change_cbk) {
			colorSelectShow_listener=this.on('colorSelectShow', function (evt) {
				_root.ColorSelector.visible = true;
				_root.color_Selected = evt.initiator;
				stage.enableMouseOver(10);
			});
			this.colorSelectShow_change_cbk=true;
		}
		
		
		// We will switch the ColorSelector to stage after creation 
		// to have it on top layer since there in no z-index possibility
		//colorSelect_listener=this.on('colorSelect', function(evt) {			
		//updateFromColor(_root.color_Selected,evt.rgba);		
		//_root.ColorSelector.visible = false;		
		//stage.enableMouseOver(0);
		//});
		if (!this.colorSelect_change_cbk) {
			colorSelect_listener=stage.on('colorSelect', function (evt) {
				updateFromColor(_root.color_Selected, evt.rgba);
				_root.ColorSelector.visible = false;
				stage.enableMouseOver(0);
			});
			this.colorSelect_change_cbk=true;
		}
		
		
		function updateFromColor(colorSelected, color) {
		
			// Get Selected Color and Update according to it 
			if (colorSelected == 'bt_color_background') {
				backgroundColor = color;
				canvas.style.backgroundColor = color;
				_root.bt_color_background.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_color_propPath') {
				right_propPathColor = color;
				right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
				_root.bt_right_color_propPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_color_handPath') {
				right_handPathColor = color;
				right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
				_root.bt_right_color_handPath.shape_1.graphics._fill.style = color;
			} else if (colorSelected == 'bt_right_prop_color_filter') {
				right_colorFilter = color;
				_root.bt_right_prop_color_filter.shape_1.graphics._fill.style = right_colorFilter;
				var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
				var col_s = col.split(",");
				right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
				//right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
				}
		}
		
		
		if (!this.bt_cleaning_change_cbk) {
			function bt_cleaning_change(evt) {
				cleaningMode = !cleaningMode;
			}
			$("#dom_overlay_container").on("change", "#bt_cleaning", bt_cleaning_change.bind(this));
			this.bt_cleaning_change_cbk = true;
		}
		
		
		if (!this.bt_stop_change_cbk) {
			bt_stop_listener=this.on('bt_stop', function (evt) {
				RandomSceneMode=false;
				XMLSceneMode=false;
				right_handPathStart = 0;
				right_handPathEnd = 360;
				stop_right();
			});
			this.bt_stop_change_cbk=true;
		}
		
		
		if (!this.bt_start_change_cbk) {
			bt_start_listener=this.on('bt_start', function (evt) {
				start_right();
			});
			this.bt_start_change_cbk=true;
		}
		
		
		if (!this.bt_pause_change_cbk) {
			bt_pause_listener=this.on('bt_pause', function (evt) {
				pause_right();
			});
			this.bt_pause_change_cbk=true;
		}
		
		
		if (!this.bt_reset_change_cbk) {
			bt_reset_listener=this.on('bt_reset', function (evt) {	
				reset_right();
			});
			this.bt_reset_change_cbk=true;
		}
		
		
		if (!this.bt_random_anim_change_cbk) {
			bt_random_anim_listener=this.on('bt_random_anim', function (evt) {
				random_anim();
			});
			this.bt_random_anim_change_cbk=true;
		}
		
		
		if (!this.bt_credits_show_change_cbk) {
			bt_credits_show_listener=this.on('bt_credits_show', function (evt) {	
				_root.credits.visible = !_root.credits.visible;
			});
			this.bt_credits_show_change_cbk=true;
		}
		
		
		if (!this.bt_clean_change_cbk) {
			bt_clean_listener=this.on('bt_clean', function (evt) {
				clean_right();
			});
			this.bt_clean_change_cbk=true;
		}
		
		
		if (!this.bt_exportImg_change_cbk) {
			bt_exportImg_listener=this.on('bt_exportImg', function (evt) {
				exportPNG_right();
			});
			this.bt_exportImg_change_cbk=true;
		}
		
		
		if (!this.bt_help_show_change_cbk) {
			bt_help_show_listener=this.on('bt_help_show', function (evt) {	
				help_show();
			});
			this.bt_help_show_change_cbk=true;
		}
		
		
		if (!this.bt_go_two_change_cbk) {	
			bt_go_two_listener=this.on('bt_go_two', function (evt) {	
				purge_scene_right();	
				_root.gotoAndStop("two");
			});
			this.bt_go_two_change_cbk=true;
		}
		
		
		if (!this.bt_go_one_change_cbk) {
			bt_go_one_listener=this.on('bt_go_one', function (evt) {
				purge_scene_right();
				_root.gotoAndStop("one");
			});
			this.bt_go_one_change_cbk=true;
		}
		
		if (!this.bt_start_record_change_cbk) {
			bt_start_record_listener = this.on('bt_start_record', function (evt) {
				startGIFEncoding();	
			});
			this.bt_start_record_change_cbk=true;
		}
		
		
		if (!this.bt_stop_record_change_cbk) {
			bt_stop_record_listener = this.on('bt_stop_record', function (evt) {
				stopGIFEncoding();	
			});
			this.bt_stop_record_change_cbk=true;
		}
		
		
		if(!this.bt_GIFGrain_change_cbk) {		
			function bt_GIFGrain_change(evt) {
				var regex = /[^0-9]/g;
				evt.target.value = evt.target.value.replace(regex, "");
				evt.target.maxlength = 5;
				GIFGrain = evt.target.value;		
			}
			$("#dom_overlay_container").on("keyup", "#bt_GIFGrain", bt_GIFGrain_change.bind(this));
			this.bt_GIFGrain_change_cbk = true;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		/// Scene Handling
		/////////////////////////////////////////////////////////////////////////////////////////
		
		function build_scene_right() {
			stage.addChild(right_axisShape);
			right_armDisplay.addChild(right_armShape);
			stage.addChild(right_armBitmap);
			right_propPathDisplay.addChild(right_propShape);
			stage.addChild(right_propPathBitmap);
			stage.addChild(right_objHandleShape);
			stage.addChild(right_objBitmap);
			stage.addChild(_root.ColorSelector);	
		}
		
		
		function purge_scene_right() {
		
			_root.credits.visible = false;		
			stop_right();
			//clean_right();
				
			right_armShape.uncache();
			right_armShape.graphics.clear();
			right_armDisplay.uncache();
			right_armDisplay.removeChild(right_armShape);
			stage.removeChild(right_armBitmap);
			
			right_propShape.uncache();
			right_propShape.graphics.clear();
			right_propPathDisplay.uncache();
			right_propPathDisplay.removeChild(right_propShape);
			stage.removeChild(right_propPathBitmap);
			
			right_objHandleShape.graphics.clear();
			if (right_objBodyShape != null) {
				right_objBodyShape.uncache();
				right_objBodyShape.graphics.clear();
				right_objDisplay.removeChild(right_objBodyShape);
				right_objBodyShape = null;
			}	
			right_objDisplay.uncache();	
			stage.removeChild(right_objBitmap);
		
			stage.removeChild(right_objHandleShape);
		
			right_axisShape.graphics.clear();	
			stage.removeChild(right_axisShape);
				
			stage.removeChild(_root.ColorSelector);
			
			$("#dom_overlay_container").off("change", "#bt_right_propChoice");
			_root.bt_right_propChoice_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_armWay");
			_root.bt_right_armWay_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_propPathViewMode");
			_root.bt_right_propPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_handPathViewMode");
			_root.bt_right_handPathViewMode_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_ratio");
			_root.bt_right_ratio_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_nbloops");
			_root.bt_right_nbloops_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_armAngle");
			_root.bt_right_armAngle_change_cbk = false;
			$("#dom_overlay_container").off("keyup", "#bt_right_propAngle");
			_root.bt_right_propAngle_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_shadow");
			_root.bt_right_shadow_change_cbk = false;	
			$("#dom_overlay_container").off("change", "#bt_right_bluring");
			_root.bt_right_bluring_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_prop_setColorFilter");
			_root.bt_right_prop_setColorFilter_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_showAxis");
			_root.bt_right_showAxis_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_right_cleaning");
			_root.bt_right_cleaning_change_cbk = false;	
			
			_root.off('bt_slider',bt_slider_listener);
			_root.bt_slider_change_cbk=false;	
			_root.off('colorSelectShow',colorSelectShow_listener);
			_root.colorSelectShow_change_cbk=false;
			_root.off('bt_stop',bt_stop_listener);
			_root.bt_stop_change_cbk=false;
			_root.off('bt_start',bt_start_listener);
			_root.bt_start_change_cbk=false;
			_root.off('bt_pause',bt_pause_listener);
			_root.bt_pause_change_cbk=false;
			_root.off('bt_reset',bt_reset_listener);	
			_root.bt_reset_change_cbk=false;	
			_root.off('bt_random_anim',bt_random_anim_listener);
			_root.bt_random_anim_change_cbk=false;
			_root.off('bt_credits_show',bt_credits_show_listener);
			_root.bt_credits_show_change_cbk=false;
			_root.off('bt_clean',bt_clean_listener);
			_root.bt_clean_change_cbk=false;
			_root.off('bt_exportImg',bt_exportImg_listener);
			_root.bt_exportImg_change_cbk=false;
			_root.off('bt_help_show',bt_help_show_listener);
			_root.bt_help_show_change_cbk=false;
			_root.off('bt_go_two',bt_go_two_listener);	
			_root.bt_go_two_change_cbk=false;
			_root.off('bt_go_one',bt_go_one_listener);	
			_root.bt_go_one_change_cbk=false;
			_root.off('bt_start_record', bt_start_record_listener);
			_root.bt_start_record_change_cbk=false;
			_root.off('bt_stop_record', bt_stop_record_listener);
			_root.bt_stop_record_change_cbk=false;
			
			
			if(GIFEncoding == true)
			{
				stopGIFEncoding();
			}
			
			$("#dom_overlay_container").off("keyup", "#bt_GIFGrain");
			_root.bt_GIFGrain_change_cbk = false;
			$("#dom_overlay_container").off("change", "#bt_cleaning");
			_root.bt_cleaning_change_cbk = false;	
			
			stage.off('colorSelect',colorSelect_listener);
			_root.colorSelect_change_cbk=false;
		}
		
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Functions 
		/////////////////////////////////////////////////////////////////////////////////////////
		
		function stop_right() {
			if (animRunning == true) {
				createjs.Ticker.off("tick", animTimer);
				if(cleaningMode == true)
				{
					clean_right();
				}
				_root.infoMode.text = "";
				animRunning = false;
			}	
		}
		
		
		function pause_right() {
			pauseMode = !pauseMode;
			createjs.Ticker.paused = pauseMode;
		}
		
		
		function clean_right() {
			_root.credits.visible = false;		
			right_objHandleShape.graphics.clear();
			if (right_objBodyShape != null) {
				right_objBodyShape.uncache();
				right_objBodyShape.graphics.clear();
				right_objDisplay.removeChild(right_objBodyShape);
				right_objBodyShape = null;
			}
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
			right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_objDisplay.filters = [];
			right_objDisplay.cache(0, 0, displayWidth, displayHeight);
			right_objBitmapData.draw(right_objDisplay);
		
			right_armShape.uncache();
			right_armShape.graphics.clear();
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_armDisplay.filters = [];
			right_armDisplay.cache(0, 0, displayWidth, displayHeight);
			right_armBitmapData.draw(right_armDisplay);
		
			right_propShape.uncache();
			right_propShape.graphics.clear();
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
			right_propPathDisplay.filters = [];
			right_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
			right_propPathBitmapData.draw(right_propPathDisplay);
		}
		
		
		function init_right() {
		
			// Init Parameters	
			right_ratio = -4;
			right_shadowMode = false;
			right_bluringMode = true;
			right_cleaningMode = true;
			right_armWay = "out";
			right_showAxis = false;
			right_nbloops = -1;
			right_clockSpeed = 2;
			right_setColorFilter = false;
			right_cur_nbloops = 0;
			right_axisInitdx = 400;
			right_axisInitdy = 300;
			right_armLength = 100;
			right_handPathColor = 'rgba(0,255,0,1)';
			right_handPathClock = 0;
			right_handPathStart = 0;
			right_handPathEnd = 360;
			right_armInitdx = right_axisInitdx;
			right_armInitdy = right_axisInitdy;
			right_armAngle = 0;
			right_handPathSize = _root.JSpyroRightHandPathSize;
			right_handPathViewMode = 2;
			right_propLength = 50;
			right_objStrokeSize = _root.JSpyroRightObjStrokeSize;
			right_propPathColor = 'rgba(226,0,0,1)';
			right_colorFilter = 'rgba(252,242,229,1)';	
			right_propInitdx = right_axisInitdx;
			right_propInitdy = right_axisInitdy;
			right_propAngle = 0;
			right_propChoice = 4;
			right_propPathSize = _root.JSpyroRightPropPathSize;
			right_propPathViewMode = 3;	
			right_objHandleSize = _root.JSpyroRightObjHandleSize;
			right_objHandleColor = _root.JSpyroRightColorObjHandle;
			right_poiStringSize = _root.JSpyroRightPoiStringSize;
			right_poiRadius = _root.JSpyroRightPoiRadius;
			backgroundColor = _root.JSpyroColorBackground;
			animSpeedValue = _root.JSpyroSpeed;
			scaling = _root.JSpyroScaling;
			GIFGrain = _root.JSpyroGIFGrain;
			RandomSceneMode = false;
			cleaningMode = _root.JSpyroCleaningMode;	
			
			//if(RandomSceneMode == true)
			//{	
			//	right_nbloops = 1;	
			//}
		
			//	if (right_objBodyShape!=null) {
			//		right_objDisplay.removeChild(right_objBodyShape);
			//		right_objBodyShape=null;
			//	}
		
			// Set Right Panel
			setParameters_right();
		
			// Do Init Action
			canvas.style.backgroundColor = backgroundColor;	
			_root.credits.visible = false;
			_root.ColorSelector.visible = false;
			update_scaling(scaling);	
			XMLSceneMode = false;	
		}
		
		
		function getParameters_right() {
		
			setTimeout(function () {
				right_propChoice = document.getElementById("bt_right_propChoice").value;
				right_armWay = document.getElementById("bt_right_armWay").value;
				right_ratio = document.getElementById("bt_right_ratio").value;
				right_nbloops = document.getElementById("bt_right_nbloops").value;
				right_armAngle = document.getElementById("bt_right_armAngle").value;
				right_propAngle = document.getElementById("bt_right_propAngle").value;
				right_propPathViewMode = document.getElementById("bt_right_propPathViewMode").value;
				right_handPathViewMode = document.getElementById("bt_right_handPathViewMode").value;
				right_setColorFilter = document.getElementById("bt_right_prop_setColorFilter").checked;
				right_shadowMode = document.getElementById("bt_right_shadow").checked;
				right_bluringMode = document.getElementById("bt_right_bluring").checked;
				right_showAxis = document.getElementById("bt_right_showAxis").checked;
				right_cleaningMode = document.getElementById("bt_right_cleaning").checked;
				GIFGrain = document.getElementById("bt_GIFGrain").value;
				cleaningMode = document.getElementById("bt_cleaning").checked;
		
				// Get the Color Values and do related actions
				updateFromColor('bt_color_background', backgroundColor);
				updateFromColor('bt_right_color_handPath', right_handPathColor);
				updateFromColor('bt_right_color_propPath', right_propPathColor);
				updateFromColor('bt_right_prop_color_filter', right_colorFilter);
		
				// Get the Sliders Values and do related actions
				updateFromSlider('bt_right_axisInitdx');
				updateFromSlider('bt_right_axisInitdy');
				updateFromSlider('bt_right_clockSpeed');
				updateFromSlider('bt_right_armLength');
				updateFromSlider('bt_right_propLength');
				updateFromSlider('bt_speed');
				updateFromSlider('bt_scale');
			}, 0);
		}
		
		
		function setParameters_right() {
			right_handPathClock = right_handPathStart;
		
			setTimeout(function () {
				document.getElementById("bt_right_propChoice").value = right_propChoice;
				document.getElementById("bt_right_armWay").value = right_armWay;
				document.getElementById("bt_right_ratio").value = right_ratio;
				document.getElementById("bt_right_nbloops").value = right_nbloops;
				document.getElementById("bt_right_armAngle").value = right_armAngle;
				document.getElementById("bt_right_propAngle").value = right_propAngle;
				document.getElementById("bt_right_propPathViewMode").value = right_propPathViewMode;
				document.getElementById("bt_right_handPathViewMode").value = right_handPathViewMode;
				document.getElementById("bt_right_prop_setColorFilter").checked = right_setColorFilter;
				document.getElementById("bt_right_shadow").checked = right_shadowMode;
				document.getElementById("bt_right_bluring").checked = right_bluringMode;
				document.getElementById("bt_right_showAxis").checked = right_showAxis;
				document.getElementById("bt_right_cleaning").checked = right_cleaningMode;		
		
				// Update the Colorization Panel		
				_root.bt_color_background.shape_1.graphics._fill.style = backgroundColor;
				_root.bt_right_color_propPath.shape_1.graphics._fill.style = right_propPathColor;
				_root.bt_right_color_handPath.shape_1.graphics._fill.style = right_handPathColor;
				_root.bt_right_prop_color_filter.shape_1.graphics._fill.style = right_colorFilter;
		
				// Update the Sliders Panel
				_root.bt_right_axisInitdx.setSlider(right_axisInitdx);
				_root.bt_right_axisInitdy.setSlider(right_axisInitdy);
				_root.bt_right_clockSpeed.setSlider(right_clockSpeed);
				_root.bt_right_armLength.setSlider(right_armLength);
				_root.bt_right_propLength.setSlider(right_propLength);
				_root.bt_speed.setSlider(animSpeedValue);
				_root.bt_scale.setSlider(scaling);
				
				document.getElementById("bt_GIFGrain").value = GIFGrain;		
				document.getElementById("bt_cleaning").checked = cleaningMode;
				createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;
				canvas.style.backgroundColor = backgroundColor;
			
			}, 0);
			
			var col = right_colorFilter.substring(5, right_colorFilter.length - 1);
			var col_s = col.split(",");
			right_propColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			//right_armColorFilter = new createjs.ColorFilter(col_s[0] / 255, col_s[1] / 255, col_s[2] / 255, col_s[3]);
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
			update_right_shadow();
			update_right_bluring();	
			drawAxis_right();	
			if (RandomSceneMode==true) {
				_root.infoMode.text = "RANDOM MODE\n";
			} else {
				_root.infoMode.text = "";
			}
			
		}
		
		
		function start_right() {
			
			// Get Parameters values from Panel	
			//getParameters_right();
			if(pauseMode == false)
			{
				right_handPathClock = right_handPathStart;		
				right_cur_nbloops = 0;	
			}
			else {
				pauseMode = false;
			}
			
			if (animRunning == true) {		
				if (cleaningMode == true) {
					clean_right();
				}
				console.log("Right Anim already running : restart !");
			} else {
				animRunning = true;
				_root.infoMode.text = "";
				__start_right();
			}
		}
		
		
		function __start_right() {
			//	if (right_drawShapeTimer!=null&&right_drawShapeTimer.running==true) {
			//		right_drawShapeTimer.stop();
			//	}
		
			right_cur_nbloops = 0;
		
			right_handPathdx = right_armLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
			right_handPathdy = right_armLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
			right_propPathdx = right_handPathdx + right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
			right_propPathdy = right_handPathdy + right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
		
			if (cleaningMode == true) {
				right_armShape.graphics.clear();
				right_propShape.graphics.clear();
				right_objHandleShape.graphics.clear();		
			}
			/*
			if(right_bluringMode == true) {					
				right_armShape.filters=[right_armBlurFilter];						
				right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);												
				right_propShape.filters=[right_propBlurFilter];	
				right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));																
			}
			else
			{	
				right_armShape.filters=[];
				right_propShape.filters=[];		
				right_armShape.uncache();
				right_propShape.uncache();
			*/
			if (right_objBodyShape != null) {
				right_objBodyShape.filters = [];
				right_objBodyShape.uncache();
			}
			//}
		
			if (right_shadowMode == true) {
				right_armShape.shadow = right_armShadow;
				right_propShape.shadow = right_propShadow;
			}
		
			right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
			right_armShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
			right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			right_propShape.graphics.moveTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
			right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
		
			animTimer = createjs.Ticker.on("tick", run_right);
			createjs.Ticker.interval = animSpeedValueMax - animSpeedValue;
		}
		
		
		function run_right(evt) {
			//if ((right_handPathClock>right_handPathEnd) || (right_nbloops != -1 && right_cur_nbloops >= right_nbloops) || (_root.pauseMode == true)) {			
			if (right_nbloops != -1 && right_cur_nbloops >= right_nbloops) {
				stop_right();
				if (RandomSceneMode==true) {
					random_anim();
				}
				return;
			} else if (pauseMode == true) {
				return;
			}
		
		
			if (right_shadowMode == true) {
				right_armShape.shadow = right_armShadow;
				right_propShape.shadow = right_propShadow;
			}
		
			var right_handPathdxOld;
			var right_handPathdyOld;
			right_handPathdxOld = right_handPathdx;
			right_handPathdyOld = right_handPathdy;
		
			right_handPathdx = right_armLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
			right_handPathdy = right_armLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock));
		
			if (right_handPathViewMode != 0) {
				if (right_handPathViewMode == 1) {
					// Comet Mode		
					right_armShape.graphics.clear();
					right_armBitmapData.clearRect(0, 0, displayWidth, displayHeight);
					right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
				}
		
				if (right_armWay == "in") {
					right_armShape.graphics.moveTo(right_handPathdxOld + right_armInitdx, -right_handPathdyOld + right_armInitdy);
					right_armShape.graphics.lineTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
				} else {
					right_armShape.graphics.moveTo(-right_handPathdxOld + right_armInitdx, -right_handPathdyOld + right_armInitdy);
					right_armShape.graphics.lineTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
				}
		
				/*if (right_bluringMode==true) {	
					// Update Cache 
					right_armShape.filters=[right_armBlurFilter];						
					right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);		
				}*/
		
				right_armDisplay.filters = [];
				right_armDisplay.cache(0, 0, displayWidth, displayHeight);
				right_armBitmapData.draw(right_armDisplay);
				/*if (right_bluringMode==true) {
					if(right_setColorFilter == true)
					{
						right_armBitmapData.colorTransform(right_armBitmapData.rect, right_armColorFilter);
					}		
				}*/
			}
		
			var right_propPathdxOld;
			var right_propPathdyOld;
			right_propPathdxOld = right_propPathdx;
			right_propPathdyOld = right_propPathdy;
		
			right_propPathdx = right_handPathdx + right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
			right_propPathdy = right_handPathdy + right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
		
			if (right_propPathViewMode != 0) {
				if (right_propPathViewMode == 1 && right_propChoice == 0) {
					// Comet Mode only with no object		
					right_propShape.graphics.clear();
					right_propPathBitmapData.clearRect(0, 0, displayWidth, displayHeight);
					right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
				}
		
				// Draw Prop only if No object or Prop Path is 'Path' or 'Path+CometProp' or 'Path+Prop'
				if (right_propChoice == 0 || right_propPathViewMode == 2 || right_propPathViewMode == 4 || right_propPathViewMode == 5) {
					if (right_armWay == "in") {
						right_propShape.graphics.moveTo(right_propPathdxOld + right_propInitdx, -right_propPathdyOld + right_propInitdy);
						right_propShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					} else {
						right_propShape.graphics.moveTo(-right_propPathdxOld + right_propInitdx, -right_propPathdyOld + right_propInitdy);
						right_propShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					}
		
					/*if (right_bluringMode==true) {
						// Update Cache			
						right_propShape.filters=[right_propBlurFilter];	
						right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));																															
					}*/
		
					right_propPathDisplay.filters = [];
					right_propPathDisplay.cache(0, 0, displayWidth, displayHeight);
					right_propPathBitmapData.draw(right_propPathDisplay);
					/*if (right_bluringMode==true) {
						if(right_setColorFilter == true)
						{		
							right_propPathBitmapData.colorTransform(right_propPathBitmapData.rect, right_propColorFilter);
						}
					}*/
				}
			}
		
		
			if (right_propPathViewMode != 0 && right_propPathViewMode != 2) {
				drawright_propObj();
			}
		
			if (right_handPathClock >= right_handPathEnd) {
				right_handPathClock = 0;
				right_cur_nbloops++;
				if (right_cleaningMode == true) {
					clean_right();
				} else {
					//right_armShape.graphics.clear();
					//			//right_propShape.graphics.clear();
					//				if (right_shadowMode==true) {	
					//	}
		
					right_objHandleShape.graphics.clear();
					right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
					right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
					right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
				}
			} else {
				right_handPathClock += right_clockSpeed;
			}
			
			if(GIFEncoding == true)
			{
				if(GIFGrainCpt ==0)
				{
					GIFEncoder.addFrame(drawGIFCanvas(canvas), {delay: GIFFrameDelay});	
					GIFCpt++;
				}
				GIFGrainCpt = (GIFGrainCpt+1)%GIFGrain;
			}
			//	stage.update(evt);
		}
		
		
		function cloneCanvas(oldCanvas) {
		
		    //create a new canvas
		    var newCanvas = document.createElement('canvas');
		   	var context = newCanvas.getContext('2d');
		    newCanvas.width = GIFWidth;
		    newCanvas.height = GIFHeight;	
			context.fillStyle = backgroundColor;
		    context.fillRect(0, 0, GIFWidth, GIFHeight);
			
		    context.drawImage(oldCanvas,0,0,displayWidth,displayHeight,0,0,GIFWidth,GIFHeight);	
		    return newCanvas;
		}
		
		
		function drawGIFCanvas(oldCanvas) {
			var BitmapDataExport = new createjs.BitmapData(null, displayWidth, displayHeight, backgroundColor);
			var bitmapExport = new createjs.Bitmap(BitmapDataExport.canvas);
		
			var axisDisplay = new createjs.Container();
			var right_axisShapeClone = right_axisShape.clone(true);
			axisDisplay.addChild(right_axisShapeClone);
			axisDisplay.filters = [];
			axisDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(axisDisplay)
			axisDisplay.removeChild(right_axisShapeClone);	
			axisDisplay.uncache();
		
			var right_armBitmapDisplay = new createjs.Container();
			var right_armBitmapClone = new createjs.Bitmap(right_armBitmapData.canvas);
			right_armBitmapClone.scaleX = scaling;	
			right_armBitmapClone.scaleY = scaling;
			right_armBitmapDisplay.addChild(right_armBitmapClone);	
			right_armBitmapDisplay.filters = [];	
			right_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_armBitmapDisplay);
			right_armBitmapDisplay.removeChild(right_armBitmapClone);	
			right_armBitmapDisplay.uncache();
			
			var right_propPathBitmapDisplay = new createjs.Container();
			var right_propPathBitmapClone = new createjs.Bitmap(right_propPathBitmapData.canvas);
			right_propPathBitmapClone.scaleX = scaling;	
			right_propPathBitmapClone.scaleY = scaling;
			right_propPathBitmapDisplay.addChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.filters = [];	
			right_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_propPathBitmapDisplay);
			right_propPathBitmapDisplay.removeChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.uncache();
			
			var right_objBitmapDisplay = new createjs.Container();
			var right_objBitmapClone = new createjs.Bitmap(right_objBitmapData.canvas);
			right_objBitmapClone.scaleX = scaling;	
			right_objBitmapClone.scaleY = scaling;
			right_objBitmapDisplay.addChild(right_objBitmapClone);	
			right_objBitmapDisplay.filters = [];	
			right_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objBitmapDisplay);
			right_objBitmapDisplay.removeChild(right_objBitmapClone);	
			right_objBitmapDisplay.uncache();
			
			var right_objHandleDisplay = new createjs.Container();
			var right_objHandleShapeClone = right_objHandleShape.clone(true);
			right_objHandleDisplay.addChild(right_objHandleShapeClone);
			right_objHandleDisplay.filters = [];
			right_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objHandleDisplay);
			right_objHandleDisplay.removeChild(right_objHandleShapeClone);
			right_objHandleDisplay.uncache();
			
			return cloneCanvas(BitmapDataExport.canvas);
		}
		
		
		function cloneCanvas(oldCanvas) {
		
		    //create a new canvas
		    var newCanvas = document.createElement('canvas');
		   	var context = newCanvas.getContext('2d');
		
		    //set dimensions
		    newCanvas.width = GIFWidth;
		    newCanvas.height = GIFHeight;
		    //apply the old canvas to the new one
		    context.drawImage(oldCanvas, 0, 0,displayWidth,displayHeight,0,0,GIFWidth,GIFHeight);
		    return newCanvas;
		}
		
		
		function drawright_propObj() {
			//	0: None
			//	1: Stick
			//	2: Staff
			//	3: Poi
			//	4: Club
			//	5: Hoop
		
			if (right_propChoice == 0) {
				right_armShape.graphics.setStrokeStyle(right_handPathSize).beginStroke(right_handPathColor);
				right_propShape.graphics.setStrokeStyle(right_propPathSize).beginStroke(right_propPathColor);
			} else if (right_propChoice == 1) {
				// Draw Stick				
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(right_propPathdx + right_propInitdx, 0);
					right_objBodyShape.graphics.lineTo(right_handPathdx + right_propInitdx - right_armInitdx, -right_handPathdy + right_propInitdy - right_armInitdy);
				} else {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.graphics.lineTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(right_propInitdx - (right_armLength + right_propLength), right_propInitdy - (right_armLength + right_propLength), 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;								
				}
			} else if (right_propChoice == 2) {
				// Draw Staff
				right_propPathdxStart = right_handPathdx - right_propLength * Math.cos(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
				right_propPathdyStart = right_handPathdy - right_propLength * Math.sin(Math.PI / 2 - right_armAngleFromTime(right_handPathClock) - right_propAngleFromTime(right_handPathClock));
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(right_propPathdxStart + right_propInitdx, -right_propPathdyStart + right_propInitdy);
					right_objBodyShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
				} else {
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
					right_objBodyShape.graphics.moveTo(-right_propPathdxStart + right_propInitdx, -right_propPathdyStart + right_propInitdy);
					right_objBodyShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(right_propInitdx - (right_armLength + right_propLength), right_propInitdy - (right_armLength + right_propLength), 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;								
				}
			} else if (right_propChoice == 3) {
				// Draw Poi 
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_poiStringSize).beginStroke(right_objHandleColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		v
				if (right_armWay == "in") {
					right_objHandleShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_poiRadius, -right_poiRadius, 2 * right_poiRadius, 2 * right_poiRadius);
					right_objBodyShape.graphics.endFill();
				} else {
					right_objHandleShape.graphics.moveTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_poiRadius, -right_poiRadius, 2 * right_poiRadius, 2 * right_poiRadius);
					right_objBodyShape.graphics.endFill();
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;										
				}
			} else if (right_propChoice == 4) {
				// Draw Club
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
					right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				}
		
				right_objBodyShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
				right_objHandleShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "in") {
					right_objHandleShape.graphics.moveTo(right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_propLength / 7, -right_propLength, right_propLength * 2 / 7, right_propLength);
					right_objBodyShape.rotation = 180 * right_propAngleFromTime(right_handPathClock) / Math.PI + 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
					right_objBodyShape.graphics.endFill();
				} else {
					right_objHandleShape.graphics.moveTo(-right_handPathdx + right_armInitdx, -right_handPathdy + right_armInitdy);
					right_objHandleShape.graphics.lineTo(-right_propPathdx + right_propInitdx, -right_propPathdy + right_propInitdy);
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.beginFill(right_propPathColor, 5);
					right_objBodyShape.graphics.drawEllipse(-right_propLength / 7, -right_propLength, right_propLength * 2 / 7, right_propLength);
					right_objBodyShape.rotation = -180 * right_propAngleFromTime(right_handPathClock) / Math.PI - 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
					right_objBodyShape.graphics.endFill();
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{			
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;												
				}
			} else if (right_propChoice == 5) {
				// Draw hoop
				if (right_objBodyShape == null) {
					right_objBodyShape = new createjs.Shape();
					right_objDisplay.addChild(right_objBodyShape);
				}
		
				right_objBodyShape.graphics.clear();
				right_objHandleShape.graphics.setStrokeStyle(right_objHandleSize).beginStroke(right_objHandleColor);
				right_objHandleShape.graphics.clear();
				right_objBodyShape.graphics.setStrokeStyle(right_objStrokeSize).beginStroke(right_propPathColor);
		
				if (right_propPathViewMode == 1 || right_propPathViewMode == 4) {
					right_objBitmapData.clearRect(0, 0, displayWidth, displayHeight);
				}
		
				if (right_armWay == "out") {
					right_objBodyShape.x = -right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.drawEllipse(-right_propLength, -right_propLength, right_propLength * 2, right_propLength * 2);
					right_objBodyShape.rotation = 180 * right_propAngleFromTime(right_handPathClock) / Math.PI + 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
				} else {
					right_objBodyShape.x = right_propPathdx + right_propInitdx;
					right_objBodyShape.y = -right_propPathdy + right_propInitdy;
					right_objBodyShape.graphics.drawEllipse(-right_propLength, -right_propLength, right_propLength * 2, right_propLength * 2);
					right_objBodyShape.rotation = -180 * right_propAngleFromTime(right_handPathClock) / Math.PI - 180 * right_armAngleFromTime(right_handPathClock) / Math.PI;
				}
		
				if (right_bluringMode == true) {
					right_objBodyShape.filters = [right_propBlurFilter];
					right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
				}
				right_objDisplay.filters = [];
				right_objDisplay.cache(0, 0, displayWidth, displayHeight);
				right_objBitmapData.draw(right_objDisplay);
				if (right_setColorFilter == true) {
					if(CptColorTransform_right == 0)
					{			
						right_objBitmapData.colorTransform(right_objBitmapData.rect, right_propColorFilter);
					}
					CptColorTransform_right = (CptColorTransform_right+1)%NbColorTransform;														
				}
			}
		}
		
		
		function right_armAngleFromTime(t) {
			return t * Math.PI / 180 + right_armAngle * Math.PI / 180;
		}
		
		
		
		function right_propAngleFromTime(t) {
			return right_ratio * (t * Math.PI / 180) + right_propAngle * Math.PI / 180;
		}
		
		
		function drawAxis_right() {
			// Draw Axis 
			right_axisShape.graphics.clear();
			right_axisShape.graphics.setStrokeStyle(2).beginStroke(axisColor);
			right_axisShape.graphics.moveTo(-right_armLength - right_propLength - 5 + right_axisInitdx, 0 + right_axisInitdy);
			right_axisShape.graphics.lineTo(+right_armLength + right_propLength + 5 + right_axisInitdx, 0 + right_axisInitdy);
			right_axisShape.graphics.moveTo(0 + right_axisInitdx, -right_armLength - right_propLength - 5 + right_axisInitdy);
			right_axisShape.graphics.lineTo(0 + right_axisInitdx, +right_armLength + right_propLength + 5 + right_axisInitdy);
			right_axisShape.visible = right_showAxis;
		}
		
		
		function update_right_shadow() {
			if (right_shadowMode == true) {
				right_armShape.shadow = right_armShadow;
				right_propShape.shadow = right_propShadow;
			} else {
				right_armShape.shadow = null;
				right_propShape.shadow = null;
			}
		}
		
		
		function update_scaling(val) {
			right_axisShape.scaleX = val;
			right_axisShape.scaleY = val;
			right_armBitmap.scaleX = val;
			right_armBitmap.scaleY = val;
			right_propPathBitmap.scaleX = val;
			right_propPathBitmap.scaleY = val;
			right_objBitmap.scaleX = val;
			right_objBitmap.scaleY = val;
			right_objHandleShape.scaleX = val;
			right_objHandleShape.scaleY = val;
		}
		
		
		function update_right_bluring(val) {
			if (right_bluringMode == true) {
					/*right_armShape.filters=[right_armBlurFilter];						
					right_propShape.filters=[right_propBlurFilter];				
					right_armShape.cache(right_armInitdx-right_armLength, right_armInitdy-right_armLength, 2*right_armLength, 2*right_armLength);															
					right_propShape.cache(right_propInitdx-right_armLength-right_propLength, right_propInitdy-right_armLength-right_propLength, 2*(right_armLength+right_propLength), 2*(right_armLength+right_propLength));*/
					if (right_objBodyShape != null) {
						right_objBodyShape.filters = [right_propBlurFilter];
						right_objBodyShape.cache(-right_armLength - right_propLength, -right_armLength - right_propLength, 2 * (right_armLength + right_propLength), 2 * (right_armLength + right_propLength));
					}
				} else {
					/*right_armShape.filters=[];
					right_propShape.filters=[];
					right_armShape.uncache();
					right_propShape.uncache();*/
					if (right_objBodyShape != null) {
						right_objBodyShape.filters = [];
						right_objBodyShape.uncache();
					}
				}
		}
		
		
		function exportPNG_right() {
			// Use no standard function however
			var filename = "JSpyro.png";
			var BitmapDataExport = new createjs.BitmapData(null, displayWidth, displayHeight, backgroundColor);
			var bitmapExport = new createjs.Bitmap(BitmapDataExport.canvas);	
			
			var axisDisplay = new createjs.Container();
			right_axisShapeClone = right_axisShape.clone(true);
			axisDisplay.addChild(right_axisShapeClone);	
			axisDisplay.filters = [];
			axisDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(axisDisplay)
			axisDisplay.removeChild(right_axisShapeClone);	
			axisDisplay.uncache();
		
			var right_armBitmapDisplay = new createjs.Container();
			var right_armBitmapClone = new createjs.Bitmap(right_armBitmapData.canvas);
			right_armBitmapClone.scaleX = scaling;	
			right_armBitmapClone.scaleY = scaling;
			right_armBitmapDisplay.addChild(right_armBitmapClone);	
			right_armBitmapDisplay.filters = [];	
			right_armBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_armBitmapDisplay);
			right_armBitmapDisplay.removeChild(right_armBitmapClone);	
			right_armBitmapDisplay.uncache();
			
			var right_propPathBitmapDisplay = new createjs.Container();
			var right_propPathBitmapClone = new createjs.Bitmap(right_propPathBitmapData.canvas);
			right_propPathBitmapClone.scaleX = scaling;	
			right_propPathBitmapClone.scaleY = scaling;
			right_propPathBitmapDisplay.addChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.filters = [];	
			right_propPathBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_propPathBitmapDisplay);
			right_propPathBitmapDisplay.removeChild(right_propPathBitmapClone);	
			right_propPathBitmapDisplay.uncache();
			
			var right_objBitmapDisplay = new createjs.Container();
			var right_objBitmapClone = new createjs.Bitmap(right_objBitmapData.canvas);
			right_objBitmapClone.scaleX = scaling;	
			right_objBitmapClone.scaleY = scaling;
			right_objBitmapDisplay.addChild(right_objBitmapClone);	
			right_objBitmapDisplay.filters = [];	
			right_objBitmapDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objBitmapDisplay);
			right_objBitmapDisplay.removeChild(right_objBitmapClone);	
			right_objBitmapDisplay.uncache();
			
			var right_objHandleDisplay = new createjs.Container();
			right_objHandleShapeClone = right_objHandleShape.clone(true);
			right_objHandleDisplay.addChild(right_objHandleShapeClone);
			right_objHandleDisplay.filters = [];
			right_objHandleDisplay.cache(0, 0, displayWidth, displayHeight);
			BitmapDataExport.draw(right_objHandleDisplay);
			right_objHandleDisplay.removeChild(right_objHandleShapeClone);
			right_objHandleDisplay.uncache();
			
			BitmapDataExport.canvas.toBlob(function (blob) {
				if (window.navigator.msSaveOrOpenBlob) {
					window.navigator.msSaveBlob(blob, filename);
				} else {
					var elem = window.document.createElement('a');
					elem.href = window.URL.createObjectURL(blob);
					elem.download = filename;
					document.body.appendChild(elem);
					elem.click();
					document.body.removeChild(elem);
					// no longer need to read the blob so it's revoked
					URL.revokeObjectURL(url);
				}
			});
		}
		
		
		function help_show() {
			window.open(helpURL, '_blank');
		}
		
		
		function reset_right() {
			
			if(cleaningMode == true)	
			{
				clean_right();		
			}
			// Set the default values for parameters		
			init_right();
		
			//	init_left();
			//	right_propShape.filters=[];
			//	right_armShape.filters=[];
			//	left_propShape.filters=[];
			//	left_armShape.filters=[];
		}
			
		
		function random_anim() {
		
			RandomSceneMode = true;
			if (animRunning == true) {
				stop_right();
			}
		
			if (right_cleaningMode == true) {
				clean_right();
			}
		
			var vtmp;
			right_handPathClock = 0;
			//right_propChoice=randomNumber(1,5);
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				right_armWay = "out";
			} else {
				right_armWay = "in";
			}
			right_ratio = randomNumber(0, 6);
			vtmp = randomNumber(0, 1);
			if (vtmp == 0) {
				right_ratio = -right_ratio;
			}
			right_nbloops = randomNumber(1, 3);
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				right_armAngle = 0;
			} else if (vtmp == 1) {
				right_armAngle = 90;
			} else if (vtmp == 2) {
				right_armAngle = 180;
			} else if (vtmp == 3) {
				right_armAngle = 270;
			}
			vtmp = randomNumber(0, 4);
			if (vtmp == 0) {
				right_propAngle = 0;
			} else if (vtmp == 1) {
				right_propAngle = 90;
			} else if (vtmp == 2) {
				right_propAngle = 180;
			} else if (vtmp == 3) {
				right_propAngle = 270;
			}
			setParameters_right();
		
			pauseMode = false;
			animRunning = true;
			_root.infoMode.text = "RANDOM MODE\n";
			__start_right();
		}
		
		
		/** 
		 * Generates a truly "random" number
		 * @return Random Number
		 */
		function randomNumber(low = 0, high = 1) {
			return Math.floor(Math.random() * (1 + high - low)) + low;
		}
		
		
		function startGIFEncoding() {
		
			if(GIFEncoding == true)
			{
				console.log('GIF encoding already running !');
				return;
			}
			
			GIFEncoding = true;
			GIFGrainCpt = 0;
			GIFCpt = 0;
			GIFEncoder = new GIF({
				workers: GIFWorkers,
				quality: GIFQuality,
				debug: true,
				width:GIFWidth,
				height:GIFHeight,			
			});
			
			_root.infoMode2.text = "Record";
			
			var GIFEncoder_listener=GIFEncoder.on('finished', function(blob) {
				filenameGIF="animJSpyro.gif";
				_root.infoMode2.text = "";
				var elem = window.document.createElement('a');
				elem.href = window.URL.createObjectURL(blob);
				elem.download = filenameGIF;
				document.body.appendChild(elem);
				elem.click();
				document.body.removeChild(elem);	
		//		this.off('finished',GIFEncoder_listener);
			});	
		
		}
		
		
		function stopGIFEncoding() {
			if(GIFCpt != 0)
			{
				GIFEncoder.render();
				_root.infoMode2.text = "Rendering";
			}
			else
			{
				_root.infoMode2.text = "";
			}
			GIFEncoding = false;
			GIFGrainCpt = 0;
			GIFCpt = 0;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		///////////////// Run timeline
		/////////////////////////////////////////////////////////////////////////////////////////
		
		init_right();
		build_scene_right();
		animRunning = true;
		 if (_root.JSpyroRandomMode == true) {	
			random_anim();
		}
		else
		{
			__start_right();
		}
	}

	// actions tween:
	this.timeline.addTween(cjs.Tween.get(this).call(this.frame_0).wait(1).call(this.frame_1).wait(10).call(this.frame_11).wait(12));

	// gui_share
	this.shape = new cjs.Shape();
	this.shape.graphics.f("#2F2F2F").s().p("AgOAjQgGgEgCgJIAPAAQACAEAEAAQADAAACgDQACgCAAgEIAAgIQgFAIgFAAQgJAAgFgIQgEgHAAgMQAAgNAEgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIARAAIAAAxQABAHgDAGQgDAGgFADQgHAEgGAAQgIAAgGgEgAgEgUQgCADAAAGQAAANAGAAQAGAAAAgMQAAgNgGAAQgCAAgCADg");
	this.shape.setTransform(68.4,590.675);

	this.shape_1 = new cjs.Shape();
	this.shape_1.graphics.f("#2F2F2F").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_1.setTransform(62.7,589.575);

	this.shape_2 = new cjs.Shape();
	this.shape_2.graphics.f("#2F2F2F").s().p("AgIAoIAAg1IARAAIAAA1gAgGgXQgCgDAAgDQAAgEACgDQAEgDACABQAEgBADADQACADAAAEQAAADgCADQgDACgEABQgCgBgEgCg");
	this.shape_2.setTransform(58.1,588.4);

	this.shape_3 = new cjs.Shape();
	this.shape_3.graphics.f("#2F2F2F").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_3.setTransform(53.55,589.575);

	this.shape_4 = new cjs.Shape();
	this.shape_4.graphics.f("#2F2F2F").s().p("AgSAVQgFgIABgNQgBgNAFgHQAEgIAJAAQAEAAABACQADACADAFIAAgHIASAAIAAA1IgSAAIAAgHIAAAAQgDAEgDACQgCADgDAAQgJAAgEgIgAgGAAQAAANAGAAQAGAAAAgNQAAgNgGAAQgGAAAAANg");
	this.shape_4.setTransform(47.5,589.675);

	this.shape_5 = new cjs.Shape();
	this.shape_5.graphics.f("#2F2F2F").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgcAAQABAMAGAAIADgBIACgEIAOAAQgEASgQAAQgJAAgGgIgAgEgMQgBACAAAGIALAAQAAgFgCgDQAAgBAAAAQgBgBAAAAQgBAAAAgBQgBAAAAAAQgDAAgCADg");
	this.shape_5.setTransform(42.05,589.625);

	this.shape_6 = new cjs.Shape();
	this.shape_6.graphics.f("#2F2F2F").s().p("AgIApIAAhRIARAAIAABRg");
	this.shape_6.setTransform(37.75,588.225);

	this.shape_7 = new cjs.Shape();
	this.shape_7.graphics.f("#2F2F2F").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_7.setTransform(33.475,588.425);

	this.bt_cleaning = new lib.an_Checkbox({'id': 'bt_cleaning', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_cleaning.name = "bt_cleaning";
	this.bt_cleaning.setTransform(151.2,589.55,1,1,0,0,0,50,11);

	this.bt_speed = new lib.Slider();
	this.bt_speed.name = "bt_speed";
	this.bt_speed.setTransform(92.25,540.55,1,1,0,0,0,25,0.3);

	this.bt_scale = new lib.Slider();
	this.bt_scale.name = "bt_scale";
	this.bt_scale.setTransform(92.5,555.75,1,1,0,0,0,25,0.3);

	this.bt_color_background = new lib.ColorSelectorShow();
	this.bt_color_background.name = "bt_color_background";
	this.bt_color_background.setTransform(109.95,570.35,1,1,0,0,0,0.8,0.4);

	this.shape_8 = new cjs.Shape();
	this.shape_8.graphics.f("#2F2F2F").s().p("AgSAiQgEgIgBgNQABgNAEgHQAFgHAHAAQAHAAAGAIIAAgjIAQAAIAABRIgRAAIAAgHQgFAJgHAAQgHAAgFgIgAgGAOQABAGABADQACAEACAAQADAAABgEQACgDABgHQAAgNgHAAQgFAAgBAOg");
	this.shape_8.setTransform(56.1,538.475);

	this.shape_9 = new cjs.Shape();
	this.shape_9.graphics.f("#2F2F2F").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEACAGQADAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_9.setTransform(50.65,539.775);

	this.shape_10 = new cjs.Shape();
	this.shape_10.graphics.f("#2F2F2F").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_10.setTransform(45.35,539.775);

	this.shape_11 = new cjs.Shape();
	this.shape_11.graphics.f("#2F2F2F").s().p("AgXAnIAAhLIARAAIAAAHIABAAQAFgJAHAAQAHAAAFAIQAFAIgBANQABAMgFAIQgFAIgHAAQgHAAgFgJIgBAAIAAAdgAgGgJQABANAFAAQAHAAAAgNQAAgOgHAAQgFAAgBAOg");
	this.shape_11.setTransform(39.9,540.825);

	this.shape_12 = new cjs.Shape();
	this.shape_12.graphics.f("#2F2F2F").s().p("AgRAmIAAgSQAIAEAGAAQADAAABgBQACgCAAgDQAAgBAAAAQAAgBAAgBQAAAAgBgBQAAAAgBgBIgEgFQgJgHgEgFQgEgGAAgHQAAgKAGgHQAGgGAKAAQAHAAAHADIAAASQgHgFgFAAQgEAAgBACQAAAAAAABQgBAAAAABQAAAAAAABQAAAAAAABQAAAFAHAGQAGAEAFAGQAFAGAAAJQAAAKgHAHQgHAGgKAAQgHAAgHgDg");
	this.shape_12.setTransform(34.125,538.575);

	this.shape_13 = new cjs.Shape();
	this.shape_13.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_13.setTransform(52.1,557.225);

	this.shape_14 = new cjs.Shape();
	this.shape_14.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_14.setTransform(47.8,555.825);

	this.shape_15 = new cjs.Shape();
	this.shape_15.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgQAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_15.setTransform(43.05,557.275);

	this.shape_16 = new cjs.Shape();
	this.shape_16.graphics.f("#333333").s().p("AgKAVQgFgIAAgNQAAgMAFgIQAGgIAIAAQAGAAAGAFIAAAOQgDgCgDAAQgEAAgDADQgCAEAAAEQAAAGACADQADAEAEAAQACAAAEgCIAAAOQgGAEgGAAQgIAAgGgIg");
	this.shape_16.setTransform(38.175,557.225);

	this.shape_17 = new cjs.Shape();
	this.shape_17.graphics.f("#333333").s().p("AgRAmIAAgSQAIAEAGAAQADAAABgBQACgCAAgDQAAgBAAAAQAAgBAAgBQAAAAgBgBQAAAAgBgBIgEgFQgJgHgEgFQgEgGAAgHQAAgKAGgHQAGgGAKAAQAHAAAHADIAAASQgHgFgFAAQgEAAgBACQAAAAAAABQgBAAAAABQAAAAAAABQAAAAAAABQAAAFAHAGQAGAEAFAGQAFAGAAAJQAAAKgHAHQgHAGgKAAQgHAAgHgDg");
	this.shape_17.setTransform(33.425,556.025);

	this.shape_18 = new cjs.Shape();
	this.shape_18.graphics.f("#333333").s().p("AgSAiQgEgIAAgNQAAgNAEgHQAFgHAIAAQAFAAAGAIIAAgjIARAAIAABRIgRAAIAAgHQgGAJgGAAQgHAAgFgIgAgFAOQgBAGACADQACAEACAAQADAAABgEQACgDAAgHQAAgNgGAAQgFAAAAAOg");
	this.shape_18.setTransform(83.25,571.225);

	this.shape_19 = new cjs.Shape();
	this.shape_19.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_19.setTransform(77.55,572.475);

	this.shape_20 = new cjs.Shape();
	this.shape_20.graphics.f("#333333").s().p("AgQAWQgFgHAAgJIAAghIARAAIAAAiQAAABAAAAQAAABAAAAQABABAAAAQAAABABABQAAAAAAAAQAAAAABABQAAAAABAAQAAAAAAAAQAFAAAAgHIAAghIARAAIAAAfQAAALgGAHQgGAGgKAAQgKAAgGgGg");
	this.shape_20.setTransform(71.7,572.65);

	this.shape_21 = new cjs.Shape();
	this.shape_21.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgJQgBACgBAHQABAOAFAAQADAAACgEQACgDAAgHQAAgHgCgCQgBgDgEAAQgCAAgCADg");
	this.shape_21.setTransform(66,572.55);

	this.shape_22 = new cjs.Shape();
	this.shape_22.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_22.setTransform(61.2,572.475);

	this.shape_23 = new cjs.Shape();
	this.shape_23.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQACAEAFAAQACAAACgDQADgCAAgEIAAgIQgGAIgGAAQgIAAgEgIQgFgHgBgMQAAgNAFgHQAFgIAIAAQAGAAAFAIIABAAIAAgGIARAAIAAAxQAAAHgDAGQgCAGgHADQgFAEgHAAQgIAAgGgEgAgEgUQgCADAAAGQAAANAGAAQAHAAAAgMQAAgNgHAAQgCAAgCADg");
	this.shape_23.setTransform(55.75,573.575);

	this.shape_24 = new cjs.Shape();
	this.shape_24.graphics.f("#333333").s().p("AAFApIgLgaIgBAAIAAAaIgRAAIAAhRIARAAIAAAvIABAAIAKgTIAVAAIgSAXIASAeg");
	this.shape_24.setTransform(50.225,571.125);

	this.shape_25 = new cjs.Shape();
	this.shape_25.graphics.f("#333333").s().p("AgKAVQgFgIAAgNQAAgMAFgIQAGgIAIAAQAGAAAGAFIAAAOQgDgCgDAAQgEAAgDADQgCAEAAAEQAAAGACADQADAEAEAAQACAAAEgCIAAAOQgGAEgGAAQgIAAgGgIg");
	this.shape_25.setTransform(44.925,572.525);

	this.shape_26 = new cjs.Shape();
	this.shape_26.graphics.f("#333333").s().p("AgSAVQgFgIABgNQgBgNAFgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAGAAABgNQgBgNgGAAQgGAAAAANg");
	this.shape_26.setTransform(39.75,572.575);

	this.shape_27 = new cjs.Shape();
	this.shape_27.graphics.f("#333333").s().p("AgYAnIAAhNIASAAQAPAAAHAGQAHAGAAAKQAAAKgKAGQAMAEAAANQgBAJgGAHQgIAGgKAAgAgGAYQAGgBADgCQADgCABgEQAAgIgMAAIgBAAgAgGgHQALABAAgJQAAgEgDgCQgCgCgGAAg");
	this.shape_27.setTransform(34.05,571.35);

	this.bt_right_handPathViewMode = new lib.an_ComboBox({'id': 'bt_right_handPathViewMode', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 3, None, 0, Comet, 1, Path, 2', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_right_handPathViewMode.name = "bt_right_handPathViewMode";
	this.bt_right_handPathViewMode.setTransform(77,237.05,0.65,0.9091,0,0,0,50.1,11.1);

	this.bt_right_color_handPath = new lib.ColorSelectorShow();
	this.bt_right_color_handPath.name = "bt_right_color_handPath";
	this.bt_right_color_handPath.setTransform(85.85,217.15,1,1,0,0,0,0.6,-0.1);

	this.bt_right_propAngle = new lib.an_TextInput({'id': 'bt_right_propAngle', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_right_propAngle.name = "bt_right_propAngle";
	this.bt_right_propAngle.setTransform(93.45,200,0.3,0.9091,0,0,0,50,11.2);

	this.bt_right_armAngle = new lib.an_TextInput({'id': 'bt_right_armAngle', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_right_armAngle.name = "bt_right_armAngle";
	this.bt_right_armAngle.setTransform(93.45,179.45,0.3,0.6818,0,0,0,50,11.1);

	this.bt_right_ratio = new lib.an_TextInput({'id': 'bt_right_ratio', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_right_ratio.name = "bt_right_ratio";
	this.bt_right_ratio.setTransform(93.5,142.6,0.3,0.6818,0,0,0,50.1,11);

	this.bt_right_nbloops = new lib.an_TextInput({'id': 'bt_right_nbloops', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_right_nbloops.name = "bt_right_nbloops";
	this.bt_right_nbloops.setTransform(93.5,160.95,0.3,0.6818,0,0,0,50.1,11.1);

	this.bt_right_propChoice = new lib.an_ComboBox({'id': 'bt_right_propChoice', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 6, None, 0, Stick, 1, Staff, 2, Poï, 3, Club, 4, Hoop, 5', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_right_propChoice.name = "bt_right_propChoice";
	this.bt_right_propChoice.setTransform(78.55,95.85,0.6,0.9091,0,0,0,50.1,11);

	this.bt_right_armWay = new lib.an_ComboBox({'id': 'bt_right_armWay', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 2, Out, out, In, in', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_right_armWay.name = "bt_right_armWay";
	this.bt_right_armWay.setTransform(78.5,118.95,0.6,0.9091,0,0,0,50,11);

	this.shape_28 = new cjs.Shape();
	this.shape_28.graphics.f("#333333").s().p("AgXAnIAAhLIARAAIAAAHIABAAQAFgJAHAAQAHAAAFAIQAFAIAAANQAAAMgFAIQgFAIgHAAQgHAAgFgJIgBAAIAAAdgAgGgJQABANAFAAQAHAAAAgNQAAgOgHAAQgFAAgBAOg");
	this.shape_28.setTransform(40,97.425);

	this.shape_29 = new cjs.Shape();
	this.shape_29.graphics.f("#333333").s().p("AgQAVQgGgHAAgNQAAgOAFgHQAHgIAKAAQAMAAAFAIQAHAHAAAOQAAANgHAHQgGAIgLAAQgKAAgGgIgAgEgKQgBAEAAAGQgBANAGAAQADAAACgCQACgDgBgIQABgGgCgEQgCgDgDAAQgCAAgCADg");
	this.shape_29.setTransform(34.1,96.4);

	this.shape_30 = new cjs.Shape();
	this.shape_30.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAHgLAHAAIACABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_30.setTransform(29.3,96.325);

	this.shape_31 = new cjs.Shape();
	this.shape_31.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAHQAHAGAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_31.setTransform(23.975,95.2);

	this.shape_32 = new cjs.Shape();
	this.shape_32.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_32.setTransform(69.2,180.675);

	this.shape_33 = new cjs.Shape();
	this.shape_33.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_33.setTransform(64.9,179.275);

	this.shape_34 = new cjs.Shape();
	this.shape_34.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEAEAAQACAAACgDQACgCABgEIAAgIQgGAIgGAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIABAAIAAgGIAQAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAAAgMQAAgNgHAAQgCAAgCADg");
	this.shape_34.setTransform(60.15,181.725);

	this.shape_35 = new cjs.Shape();
	this.shape_35.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_35.setTransform(54.45,180.625);

	this.shape_36 = new cjs.Shape();
	this.shape_36.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgRgCgPIAAAAQgBAQgEAQg");
	this.shape_36.setTransform(48.325,179.5);

	this.shape_37 = new cjs.Shape();
	this.shape_37.graphics.f("#333333").s().p("AASAcIAAgfQAAgHgFAAQgFAAAAAHIAAAfIgQAAIAAggQAAgBAAAAQAAgBAAAAQAAgBgBAAQAAgBAAgBQgBAAAAAAQAAgBgBAAQAAAAgBAAQAAAAgBAAQAAAAgBAAQAAAAgBAAQAAAAAAABQgBAAAAAAQgCACAAAEIAAAfIgRAAIAAg1IARAAIAAAGQAIgIAHAAQAIAAADAJQAEgFADgCQAEgCAFAAQAMAAAAARIAAAmg");
	this.shape_37.setTransform(37.575,180.6);

	this.shape_38 = new cjs.Shape();
	this.shape_38.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_38.setTransform(31.25,180.625);

	this.shape_39 = new cjs.Shape();
	this.shape_39.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgRgCgPIAAAAQgBAQgEAQg");
	this.shape_39.setTransform(25.725,179.5);

	this.shape_40 = new cjs.Shape();
	this.shape_40.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_40.setTransform(69.2,199.375);

	this.shape_41 = new cjs.Shape();
	this.shape_41.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_41.setTransform(64.9,197.975);

	this.shape_42 = new cjs.Shape();
	this.shape_42.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEAEAAQACAAACgDQACgCABgEIAAgIQgGAIgGAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIABAAIAAgGIAQAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAAAgMQAAgNgHAAQgCAAgCADg");
	this.shape_42.setTransform(60.15,200.425);

	this.shape_43 = new cjs.Shape();
	this.shape_43.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_43.setTransform(54.45,199.325);

	this.shape_44 = new cjs.Shape();
	this.shape_44.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgRIAAAAQgBARgEAQg");
	this.shape_44.setTransform(48.325,198.2);

	this.shape_45 = new cjs.Shape();
	this.shape_45.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIAAANQAAAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_45.setTransform(39.05,200.425);

	this.shape_46 = new cjs.Shape();
	this.shape_46.graphics.f("#333333").s().p("AgQAVQgGgHgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBACgBAHQABAOAFAAQADgBACgDQACgDAAgHQAAgHgCgCQgBgDgEAAQgCAAgCADg");
	this.shape_46.setTransform(33.15,199.4);

	this.shape_47 = new cjs.Shape();
	this.shape_47.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_47.setTransform(28.35,199.325);

	this.shape_48 = new cjs.Shape();
	this.shape_48.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAALgHAGQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_48.setTransform(23.025,198.2);

	this.shape_49 = new cjs.Shape();
	this.shape_49.graphics.f("#333333").s().p("AgOAmIAHgXIgRg0IARAAIAEAOIADAOIAAAAIACgJIAGgTIARAAIgXBLg");
	this.shape_49.setTransform(39.375,122.2);

	this.shape_50 = new cjs.Shape();
	this.shape_50.graphics.f("#333333").s().p("AgSAVQgFgIABgNQgBgNAFgHQAEgIAJAAQAEAAABACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgDAAQgJAAgEgIgAgGAAQAAANAGAAQAGAAABgNQgBgNgGAAQgGAAAAANg");
	this.shape_50.setTransform(33.55,121.125);

	this.shape_51 = new cjs.Shape();
	this.shape_51.graphics.f("#333333").s().p("AAKAnIgIgjIgCgKIAAAAIgCALIgHAiIgPAAIgThNIARAAIAKAuIAJguIAPAAIAJAuIAKguIASAAIgTBNg");
	this.shape_51.setTransform(26.3,119.9);

	this.shape_52 = new cjs.Shape();
	this.shape_52.graphics.f("#333333").s().p("AgTAWIAGgMQAIAFAEAAQAAAAABAAQAAAAAAAAQAAAAABgBQAAAAAAAAQABgBAAAAQAAAAABAAQAAgBAAAAQAAAAAAgBIgBgCIgIgEQgGgDgDgDQgDgDAAgGQABgHAFgFQAGgGAGAAQAJAAALAHIgGAMQgIgFgFAAQgDAAAAAEIABADIAGACQAHADAEADQADADAAAGQAAAIgFAGQgGAFgIAAQgJAAgKgHg");
	this.shape_52.setTransform(69.45,161.925);

	this.shape_53 = new cjs.Shape();
	this.shape_53.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIAAANQAAAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_53.setTransform(64.25,162.975);

	this.shape_54 = new cjs.Shape();
	this.shape_54.graphics.f("#333333").s().p("AgQAVQgGgHgBgNQAAgNAHgIQAFgIALAAQALAAAHAIQAFAIAAANQAAANgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBADgBAGQABANAFAAQADAAACgDQACgCAAgIQAAgGgCgDQgBgDgEgBQgCABgCADg");
	this.shape_54.setTransform(58.35,161.95);

	this.shape_55 = new cjs.Shape();
	this.shape_55.graphics.f("#333333").s().p("AgQAVQgGgHgBgNQAAgNAHgIQAFgIALAAQALAAAHAIQAFAIAAANQAAANgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgCADABAGQAAANAFAAQADAAACgDQABgCAAgIQAAgGgBgDQgCgDgDgBQgCABgCADg");
	this.shape_55.setTransform(52.75,161.95);

	this.shape_56 = new cjs.Shape();
	this.shape_56.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_56.setTransform(47.875,160.75);

	this.shape_57 = new cjs.Shape();
	this.shape_57.graphics.f("#333333").s().p("AAFApIAAghIgBgFQAAAAgBAAQAAgBgBAAQAAAAgBAAQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAhRIARAAIAAAjIAAAAQAGgIAIAAQAGAAADADQADAEAAAGIAAApg");
	this.shape_57.setTransform(68.95,215.275);

	this.shape_58 = new cjs.Shape();
	this.shape_58.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_58.setTransform(64.175,215.975);

	this.shape_59 = new cjs.Shape();
	this.shape_59.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgQAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_59.setTransform(59.25,216.725);

	this.shape_60 = new cjs.Shape();
	this.shape_60.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAALgHAGQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_60.setTransform(53.575,215.5);

	this.shape_61 = new cjs.Shape();
	this.shape_61.graphics.f("#333333").s().p("AgSAiQgFgIABgNQgBgNAFgHQAFgHAIAAQAGAAAFAIIAAgjIARAAIAABRIgRAAIAAgHQgFAJgHAAQgHAAgFgIgAgFAOQAAAGABADQACAEACAAQADAAACgEQABgDAAgHQAAgNgGAAQgGAAABAOg");
	this.shape_61.setTransform(44,215.375);

	this.shape_62 = new cjs.Shape();
	this.shape_62.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_62.setTransform(38.3,216.625);

	this.shape_63 = new cjs.Shape();
	this.shape_63.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgQAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_63.setTransform(32.25,216.725);

	this.shape_64 = new cjs.Shape();
	this.shape_64.graphics.f("#333333").s().p("AAIAnIAAggIgPAAIAAAgIgSAAIAAhNIASAAIAAAdIAPAAIAAgdIASAAIAABNg");
	this.shape_64.setTransform(25.95,215.5);

	this.shape_65 = new cjs.Shape();
	this.shape_65.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgJQgBACAAAHQAAAOAFAAQADAAACgEQABgDAAgHQAAgHgBgCQgCgDgDAAQgCAAgCADg");
	this.shape_65.setTransform(69.05,142.35);

	this.shape_66 = new cjs.Shape();
	this.shape_66.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgFgXQgDgDAAgDQAAgEADgDQADgDACABQAEgBADADQACADAAAEQAAADgCADQgDACgEABQgCgBgDgCg");
	this.shape_66.setTransform(64.6,141.1);

	this.shape_67 = new cjs.Shape();
	this.shape_67.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_67.setTransform(61.125,141.625);

	this.shape_68 = new cjs.Shape();
	this.shape_68.graphics.f("#333333").s().p("AgSAVQgFgIAAgNQAAgNAFgHQAFgIAHAAQAFAAABACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_68.setTransform(56.2,142.375);

	this.shape_69 = new cjs.Shape();
	this.shape_69.graphics.f("#333333").s().p("AAHAnIgNgkIgBAAIAAAkIgRAAIAAhNIAUAAQALAAAIAGQAHAGAAALQAAAGgCAGQgDAEgFACIANAkgAgHgFQALAAAAgIQAAgFgDgDQgBgCgHAAg");
	this.shape_69.setTransform(50.5,141.15);

	this.bt_credits_show = new lib.bt_credits_show();
	this.bt_credits_show.name = "bt_credits_show";
	this.bt_credits_show.setTransform(775.6,560.5,1,1,0,0,0,16,16);

	this.credits = new lib.credits();
	this.credits.name = "credits";
	this.credits.setTransform(399.6,280.15,0.8653,0.8653,0,0,0,253.7,290.1);

	this.bt_GIFGrain = new lib.an_TextInput({'id': 'bt_GIFGrain', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_GIFGrain.name = "bt_GIFGrain";
	this.bt_GIFGrain.setTransform(679,587.05,0.18,0.6818,0,0,0,50,11.1);

	this.shape_70 = new cjs.Shape();
	this.shape_70.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_70.setTransform(663.65,587.425);

	this.shape_71 = new cjs.Shape();
	this.shape_71.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgFgXQgDgDAAgDQAAgEADgDQACgCADgBQAEABADACQACADAAAEQAAADgCADQgDACgEAAQgDAAgCgCg");
	this.shape_71.setTransform(659.05,586.25);

	this.shape_72 = new cjs.Shape();
	this.shape_72.graphics.f("#333333").s().p("AgSAVQgEgIAAgNQAAgNAEgHQAEgIAJAAQADAAACACQADACADAFIAAgHIARAAIAAA1IgRAAIAAgHIAAAAQgDAEgDACQgCADgDAAQgJAAgEgIgAgGAAQAAANAGAAQAGAAAAgNQAAgNgGAAQgGAAAAANg");
	this.shape_72.setTransform(654.3,587.525);

	this.shape_73 = new cjs.Shape();
	this.shape_73.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAHgLAHAAIACABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_73.setTransform(649.5,587.425);

	this.shape_74 = new cjs.Shape();
	this.shape_74.graphics.f("#333333").s().p("AgUAeQgIgKABgUQgBgTAIgLQAIgKAOAAQARAAAHASIgRAHIgEgGQgCgCgDAAQgEAAgCAGQgCAGAAALQAAAMACAGQADAFAEAAQAJAAAAgMIgIAAIAAgPIAbAAIAAANQAAAPgIAJQgHAIgNAAQgNAAgIgLg");
	this.shape_74.setTransform(643.7,586.275);

	this.bt_stop_record = new lib.bt_stop_record();
	this.bt_stop_record.name = "bt_stop_record";
	this.bt_stop_record.setTransform(681,562,1,1,0,0,0,16,16);

	this.bt_start_record = new lib.bt_start_record();
	this.bt_start_record.name = "bt_start_record";
	this.bt_start_record.setTransform(647,562,1,1,0,0,0,16,16);

	this.infoMode2 = new cjs.Text("", "12px 'Tw Cen MT Condensed Extra Bold'", "#999999");
	this.infoMode2.name = "infoMode2";
	this.infoMode2.textAlign = "center";
	this.infoMode2.lineHeight = 16;
	this.infoMode2.lineWidth = 64;
	this.infoMode2.parent = this;
	this.infoMode2.setTransform(663.15,533);

	this.bt_random = new lib.bt_random();
	this.bt_random.name = "bt_random";
	this.bt_random.setTransform(440,564.95,1,1,0,0,0,16,16);

	this.bt_help_show = new lib.bt_help_show();
	this.bt_help_show.name = "bt_help_show";
	this.bt_help_show.setTransform(741.6,560.5,1,1,0,0,0,16,16);

	this.bt_reset = new lib.bt_reset();
	this.bt_reset.name = "bt_reset";
	this.bt_reset.setTransform(407.6,564,1,1,0,0,0,16,16);

	this.bt_exportImg = new lib.bt_exportImg();
	this.bt_exportImg.name = "bt_exportImg";
	this.bt_exportImg.setTransform(476.2,567.8,1.0004,1.0004,0,0,0,19.9,19.8);

	this.bt_stop = new lib.bt_stop();
	this.bt_stop.name = "bt_stop";
	this.bt_stop.setTransform(342,564.5,1,1,0,0,0,16,16);

	this.bt_pause = new lib.bt_pause();
	this.bt_pause.name = "bt_pause";
	this.bt_pause.setTransform(314.5,568.5,1,1,0,0,0,20,20);

	this.bt_start = new lib.bt_start();
	this.bt_start.name = "bt_start";
	this.bt_start.setTransform(283,568.5,1,1,0,0,0,20,20);

	this.bt_clean = new lib.bt_clean();
	this.bt_clean.name = "bt_clean";
	this.bt_clean.setTransform(378.6,569,1,1,0,0,0,20,20);

	this.bt_right_propPathViewMode = new lib.an_ComboBox({'id': 'bt_right_propPathViewMode', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 6, None, 0, Comet, 1, Path, 2, Prop, 3, Path+CometProp, 4, Path+Prop, 5', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_right_propPathViewMode.name = "bt_right_propPathViewMode";
	this.bt_right_propPathViewMode.setTransform(77.55,278.4,0.65,0.9091,0,0,0,50.1,11);

	this.infoMode = new cjs.Text("", "14px 'Tw Cen MT Condensed Extra Bold'", "#999999");
	this.infoMode.name = "infoMode";
	this.infoMode.textAlign = "right";
	this.infoMode.lineHeight = 17;
	this.infoMode.lineWidth = 108;
	this.infoMode.parent = this;
	this.infoMode.setTransform(790,482.35);

	this.bt_right_prop_setColorFilter = new lib.an_Checkbox({'id': 'bt_right_prop_setColorFilter', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_right_prop_setColorFilter.name = "bt_right_prop_setColorFilter";
	this.bt_right_prop_setColorFilter.setTransform(144,302.55,1,1,0,0,0,50,11);

	this.bt_right_clockSpeed = new lib.Slider();
	this.bt_right_clockSpeed.name = "bt_right_clockSpeed";
	this.bt_right_clockSpeed.setTransform(79.95,427.6,1,1,0,0,0,21.5,0.3);

	this.shape_75 = new cjs.Shape();
	this.shape_75.graphics.f("#333333").s().p("AAFApIgLgaIgBAAIAAAaIgRAAIAAhRIARAAIAAAvIABAAIAKgTIAVAAIgSAXIASAeg");
	this.shape_75.setTransform(48.625,423.725);

	this.shape_76 = new cjs.Shape();
	this.shape_76.graphics.f("#333333").s().p("AgKAVQgFgIAAgNQAAgMAFgIQAGgIAIAAQAGAAAGAFIAAAOQgDgCgDAAQgEAAgDADQgCAEAAAEQAAAGACADQADAEAEAAQACAAAEgCIAAAOQgGAEgGAAQgIAAgGgIg");
	this.shape_76.setTransform(43.325,425.125);

	this.shape_77 = new cjs.Shape();
	this.shape_77.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgNAHgHQAFgIALAAQALAAAHAIQAFAHAAANQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgBADgBAHQABAOAFAAQADAAACgDQABgEAAgHQAAgHgBgDQgCgCgDAAQgCAAgCACg");
	this.shape_77.setTransform(38.45,425.15);

	this.shape_78 = new cjs.Shape();
	this.shape_78.graphics.f("#333333").s().p("AgIApIAAhRIAQAAIAABRg");
	this.shape_78.setTransform(34,423.725);

	this.shape_79 = new cjs.Shape();
	this.shape_79.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_79.setTransform(29.725,423.925);

	this.bt_right_propLength = new lib.Slider();
	this.bt_right_propLength.name = "bt_right_propLength";
	this.bt_right_propLength.setTransform(80.35,457.5,1,1,0,0,0,21.5,0.3);

	this.bt_right_armLength = new lib.Slider();
	this.bt_right_armLength.name = "bt_right_armLength";
	this.bt_right_armLength.setTransform(79.95,442.8,1,1,0,0,0,21.5,0.3);

	this.bt_right_axisInitdy = new lib.Slider();
	this.bt_right_axisInitdy.name = "bt_right_axisInitdy";
	this.bt_right_axisInitdy.setTransform(80.35,411.65,1,1,0,0,0,21.5,0.3);

	this.bt_right_axisInitdx = new lib.Slider();
	this.bt_right_axisInitdx.name = "bt_right_axisInitdx";
	this.bt_right_axisInitdx.setTransform(80.35,395.75,1,1,0,0,0,21.5,0.3);

	this.ColorSelector = new lib.ColorSelector();
	this.ColorSelector.name = "ColorSelector";
	this.ColorSelector.setTransform(402.25,287.9,1.1993,1.1993,0,0,0,170.1,209.1);

	this.bt_right_prop_color_filter = new lib.ColorSelectorShow();
	this.bt_right_prop_color_filter.name = "bt_right_prop_color_filter";
	this.bt_right_prop_color_filter.setTransform(85.85,300.65,1,1,0,0,0,0.6,-0.1);

	this.shape_80 = new cjs.Shape();
	this.shape_80.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_80.setTransform(69.85,301.575);

	this.shape_81 = new cjs.Shape();
	this.shape_81.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAFAEQAGAEACAGQADAGAAAMIgcAAQABAMAFAAIAFgBIACgEIANAAQgDASgRAAQgJAAgGgIgAgDgMQgCACAAAGIAMAAQgBgFgBgDQgBgBAAAAQgBgBAAAAQgBAAAAgBQgBAAgBAAQgCAAgBADg");
	this.shape_81.setTransform(64.85,301.625);

	this.shape_82 = new cjs.Shape();
	this.shape_82.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_82.setTransform(60.375,300.925);

	this.shape_83 = new cjs.Shape();
	this.shape_83.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_83.setTransform(56.9,300.225);

	this.shape_84 = new cjs.Shape();
	this.shape_84.graphics.f("#333333").s().p("AgIAoIAAg1IARAAIAAA1gAgGgXQgCgDAAgDQAAgEACgDQAEgDACABQAEgBADADQACADAAAEQAAADgCADQgDACgEABQgCgBgEgCg");
	this.shape_84.setTransform(53.6,300.4);

	this.shape_85 = new cjs.Shape();
	this.shape_85.graphics.f("#333333").s().p("AgIApIAAgnIgHAAIAAgOIAHAAIAAgMQAAgIAEgEQAEgEAJAAIAHAAIAAARIgFAAIgCABIgBADIAAAHIAIAAIAAAOIgIAAIAAAng");
	this.shape_85.setTransform(50.25,300.225);

	this.shape_86 = new cjs.Shape();
	this.shape_86.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAHgLAHAAIACABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_86.setTransform(43.25,301.575);

	this.shape_87 = new cjs.Shape();
	this.shape_87.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgJQgBACgBAHQABAOAFAAQADAAACgEQACgDAAgHQAAgHgCgCQgBgDgEAAQgCAAgCADg");
	this.shape_87.setTransform(38.1,301.65);

	this.shape_88 = new cjs.Shape();
	this.shape_88.graphics.f("#333333").s().p("AgIApIAAhRIAQAAIAABRg");
	this.shape_88.setTransform(33.65,300.225);

	this.shape_89 = new cjs.Shape();
	this.shape_89.graphics.f("#333333").s().p("AgQAWQgHgIAAgOQABgMAFgIQAHgIAKAAQALAAAHAIQAFAIABAMQgBAOgFAIQgHAHgLAAQgKAAgGgHgAgEgJQgBACgBAHQABAOAFAAQADAAACgEQACgDAAgHQAAgHgCgCQgBgDgEAAQgCAAgCADg");
	this.shape_89.setTransform(29.2,301.65);

	this.shape_90 = new cjs.Shape();
	this.shape_90.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_90.setTransform(23.775,300.425);

	this.bt_right_color_propPath = new lib.ColorSelectorShow();
	this.bt_right_color_propPath.name = "bt_right_color_propPath";
	this.bt_right_color_propPath.setTransform(86.4,258.5,1,1,0,0,0,0.6,-0.1);

	this.bt_right_cleaning = new lib.an_Checkbox({'id': 'bt_right_cleaning', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_right_cleaning.name = "bt_right_cleaning";
	this.bt_right_cleaning.setTransform(124.15,378.5,1,1,0,0,0,50,11);

	this.bt_right_showAxis = new lib.an_Checkbox({'id': 'bt_right_showAxis', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_right_showAxis.name = "bt_right_showAxis";
	this.bt_right_showAxis.setTransform(124.15,359.5,1,1,0,0,0,50,11);

	this.bt_right_bluring = new lib.an_Checkbox({'id': 'bt_right_bluring', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_right_bluring.name = "bt_right_bluring";
	this.bt_right_bluring.setTransform(124.15,340.85,1,1,0,0,0,50,11);

	this.bt_right_shadow = new lib.an_Checkbox({'id': 'bt_right_shadow', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_right_shadow.name = "bt_right_shadow";
	this.bt_right_shadow.setTransform(124.15,321.85,1,1,0,0,0,50,11);

	this.shape_91 = new cjs.Shape();
	this.shape_91.graphics.f("#333333").s().p("AgIAnIAAgkIgVgpIAUAAIAJAaIAJgaIAVAAIgVApIAAAkg");
	this.shape_91.setTransform(48.775,409.9);

	this.shape_92 = new cjs.Shape();
	this.shape_92.graphics.f("#333333").s().p("AAKAnIgKgYIAAAAIgCAHIgHARIgUAAIAUgoIgSglIAUAAIAHAVIAAAAIACgGIAGgPIAUAAIgSAlIAUAog");
	this.shape_92.setTransform(48.8,393.85);

	this.shape_93 = new cjs.Shape();
	this.shape_93.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQACAEAEAAQADAAADgDQABgCAAgEIAAgIQgFAIgFAAQgJAAgFgIQgEgHAAgMQgBgNAFgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIARAAIAAAxQAAAHgCAGQgDAGgFADQgHAEgGAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAGAAAAgMQAAgNgGAAQgCAAgCADg");
	this.shape_93.setTransform(68.75,378.675);

	this.shape_94 = new cjs.Shape();
	this.shape_94.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_94.setTransform(63.05,377.575);

	this.shape_95 = new cjs.Shape();
	this.shape_95.graphics.f("#333333").s().p("AgIAnIAAg1IARAAIAAA1gAgGgXQgCgDAAgEQAAgEACgCQADgDADAAQADAAAEADQACACAAAEQAAAEgCADQgEACgDAAQgDAAgDgCg");
	this.shape_95.setTransform(58.45,376.4);

	this.shape_96 = new cjs.Shape();
	this.shape_96.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_96.setTransform(53.9,377.575);

	this.shape_97 = new cjs.Shape();
	this.shape_97.graphics.f("#333333").s().p("AgSAVQgFgIABgNQgBgNAFgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAGAAABgNQgBgNgGAAQgGAAAAANg");
	this.shape_97.setTransform(47.85,377.675);

	this.shape_98 = new cjs.Shape();
	this.shape_98.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAGAAIADgBIACgEIAPAAQgEASgRAAQgJAAgGgIgAgEgMQgBACAAAGIALAAQAAgFgCgDQAAgBAAAAQgBgBAAAAQAAAAgBgBQgBAAAAAAQgDAAgCADg");
	this.shape_98.setTransform(42.4,377.625);

	this.shape_99 = new cjs.Shape();
	this.shape_99.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_99.setTransform(38.1,376.225);

	this.shape_100 = new cjs.Shape();
	this.shape_100.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_100.setTransform(33.825,376.425);

	this.shape_101 = new cjs.Shape();
	this.shape_101.graphics.f("#333333").s().p("AgTAWIAGgMQAIAFAEAAQAAAAABAAQAAAAAAAAQAAAAABgBQAAAAAAAAQABAAAAgBQAAAAABAAQAAgBAAAAQAAAAAAgBIgBgCIgIgEQgGgDgDgDQgDgDAAgGQABgHAFgFQAGgGAGAAQAJAAALAHIgGAMQgIgFgFAAQgDAAAAAEIABADIAGACQAHADAEADQADADAAAGQAAAIgFAGQgGAFgIAAQgJAAgKgHg");
	this.shape_101.setTransform(69.45,358.875);

	this.shape_102 = new cjs.Shape();
	this.shape_102.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgGgXQgCgDAAgDQAAgEACgDQADgCADgBQAEABADACQACADAAAEQAAADgCADQgDACgEABQgDgBgDgCg");
	this.shape_102.setTransform(65.4,357.65);

	this.shape_103 = new cjs.Shape();
	this.shape_103.graphics.f("#333333").s().p("AAIAbIgIgSIgCAJIgFAJIgTAAIARgbIgRgaIATAAIAHARQABgEAHgNIATAAIgSAaIASAbg");
	this.shape_103.setTransform(60.8,358.9);

	this.shape_104 = new cjs.Shape();
	this.shape_104.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgRgCgPIAAAAQgBAQgEAQg");
	this.shape_104.setTransform(54.725,357.7);

	this.shape_105 = new cjs.Shape();
	this.shape_105.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_105.setTransform(49.05,454.925);

	this.shape_106 = new cjs.Shape();
	this.shape_106.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEACAGQADAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_106.setTransform(43.45,454.975);

	this.shape_107 = new cjs.Shape();
	this.shape_107.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_107.setTransform(38.725,453.8);

	this.shape_108 = new cjs.Shape();
	this.shape_108.graphics.f("#333333").s().p("AgXAnIAAhLIASAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAFAIgBANQABAMgFAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQAAANAFAAQAHAAgBgNQABgOgHAAQgFAAAAAOg");
	this.shape_108.setTransform(30.25,456.025);

	this.shape_109 = new cjs.Shape();
	this.shape_109.graphics.f("#333333").s().p("AgQAVQgHgHAAgOQABgMAFgIQAHgIAKAAQALAAAHAIQAFAIABAMQgBAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgCACAAAHQAAAOAGAAQADgBACgDQABgDABgHQgBgHgBgCQgBgDgEAAQgCAAgCADg");
	this.shape_109.setTransform(24.35,455);

	this.shape_110 = new cjs.Shape();
	this.shape_110.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_110.setTransform(19.55,454.925);

	this.shape_111 = new cjs.Shape();
	this.shape_111.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAALgHAGQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_111.setTransform(14.225,453.8);

	this.shape_112 = new cjs.Shape();
	this.shape_112.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAGAAADAEQADAEAAAGIAAApg");
	this.shape_112.setTransform(49.05,440.275);

	this.shape_113 = new cjs.Shape();
	this.shape_113.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEACAGQADAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_113.setTransform(43.45,440.325);

	this.shape_114 = new cjs.Shape();
	this.shape_114.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_114.setTransform(38.725,439.15);

	this.shape_115 = new cjs.Shape();
	this.shape_115.graphics.f("#333333").s().p("AASAcIAAgfQAAgHgFAAQgFAAAAAHIAAAfIgQAAIAAggQAAgBAAAAQAAgBAAAAQAAgBgBAAQAAgBAAgBQgBAAAAAAQAAgBgBAAQAAAAgBAAQAAAAgBAAQAAAAgBAAQAAAAgBAAQAAAAAAABQgBAAAAAAQgCACAAAEIAAAfIgRAAIAAg1IARAAIAAAGQAIgIAHAAQAIAAADAJQAEgFADgCQAEgCAFAAQAMAAAAARIAAAmg");
	this.shape_115.setTransform(28.775,440.25);

	this.shape_116 = new cjs.Shape();
	this.shape_116.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAGgLAHAAIADABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_116.setTransform(22.45,440.275);

	this.shape_117 = new cjs.Shape();
	this.shape_117.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgRgCgPIAAAAQgBAQgEAQg");
	this.shape_117.setTransform(16.925,439.15);

	this.shape_118 = new cjs.Shape();
	this.shape_118.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIAAANQAAAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQAAANAFAAQAGAAAAgNQAAgOgGAAQgFAAAAAOg");
	this.shape_118.setTransform(69.3,260.525);

	this.shape_119 = new cjs.Shape();
	this.shape_119.graphics.f("#333333").s().p("AgQAVQgHgHAAgNQABgNAFgIQAHgIAKAAQALAAAHAIQAFAIABANQgBANgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBADgBAGQABANAFAAQADAAACgDQACgCAAgIQAAgGgCgDQgBgEgEAAQgCAAgCAEg");
	this.shape_119.setTransform(63.4,259.5);

	this.shape_120 = new cjs.Shape();
	this.shape_120.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_120.setTransform(58.6,259.425);

	this.shape_121 = new cjs.Shape();
	this.shape_121.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAHQAHAGAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_121.setTransform(53.275,258.3);

	this.shape_122 = new cjs.Shape();
	this.shape_122.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEAEAAQACAAACgDQACgCAAgEIAAgIQgEAIgHAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIARAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAgBgMQABgNgHAAQgCAAgCADg");
	this.shape_122.setTransform(69.95,341.375);

	this.shape_123 = new cjs.Shape();
	this.shape_123.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_123.setTransform(64.25,340.275);

	this.shape_124 = new cjs.Shape();
	this.shape_124.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgFgXQgDgDAAgDQAAgEADgDQADgDACABQAEgBACADQADADAAAEQAAADgDADQgCACgEABQgCgBgDgCg");
	this.shape_124.setTransform(59.65,339.1);

	this.shape_125 = new cjs.Shape();
	this.shape_125.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_125.setTransform(56,340.275);

	this.shape_126 = new cjs.Shape();
	this.shape_126.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAGgLAIAAIACABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_126.setTransform(51.65,340.275);

	this.shape_127 = new cjs.Shape();
	this.shape_127.graphics.f("#333333").s().p("AgQAWQgFgHAAgJIAAghIARAAIAAAiQAAABAAAAQAAABAAAAQABABAAAAQAAABABABQAAAAAAAAQAAAAABABQAAAAABAAQAAAAAAAAQAFAAAAgHIAAghIARAAIAAAfQAAALgGAHQgGAGgKAAQgKAAgGgGg");
	this.shape_127.setTransform(46.4,340.45);

	this.shape_128 = new cjs.Shape();
	this.shape_128.graphics.f("#333333").s().p("AgHApIAAhRIAPAAIAABRg");
	this.shape_128.setTransform(41.85,338.925);

	this.shape_129 = new cjs.Shape();
	this.shape_129.graphics.f("#333333").s().p("AgYAnIAAhNIASAAQAPAAAHAGQAHAGAAAKQAAAKgKAGQAMAEAAANQgBAJgGAHQgIAGgKAAgAgGAYQAGgBADgCQAEgCAAgEQAAgIgMAAIgBAAgAgGgHQALABAAgJQAAgEgDgCQgCgCgGAAg");
	this.shape_129.setTransform(37.3,339.15);

	this.shape_130 = new cjs.Shape();
	this.shape_130.graphics.f("#333333").s().p("AAHAbIgHgcIgGAcIgNAAIgRg1IARAAIAHAdIAGgdIANAAIAGAdIAAAAIACgIIAFgVIARAAIgRA1g");
	this.shape_130.setTransform(67.975,320.8);

	this.shape_131 = new cjs.Shape();
	this.shape_131.graphics.f("#333333").s().p("AgQAVQgGgHgBgNQAAgNAHgIQAFgIALAAQALAAAHAIQAFAIAAANQAAANgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBADgBAGQABANAFAAQADAAACgDQACgCAAgIQAAgGgCgDQgBgDgEgBQgCABgCADg");
	this.shape_131.setTransform(61.5,320.8);

	this.shape_132 = new cjs.Shape();
	this.shape_132.graphics.f("#333333").s().p("AgSAiQgFgIABgNQgBgNAFgHQAFgHAIAAQAGAAAFAIIAAgjIASAAIAABRIgSAAIAAgHQgFAJgHAAQgIAAgEgIgAgFAOQAAAGABADQACAEACAAQADAAACgEQABgDAAgHQAAgNgGAAQgGAAABAOg");
	this.shape_132.setTransform(55.6,319.475);

	this.shape_133 = new cjs.Shape();
	this.shape_133.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAEgIAIAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgRAAIAAgHIAAAAQgDAEgDACQgCADgEAAQgIAAgEgIgAgGAAQAAANAGAAQAHAAgBgNQABgNgHAAQgGAAAAANg");
	this.shape_133.setTransform(49.7,320.825);

	this.shape_134 = new cjs.Shape();
	this.shape_134.graphics.f("#333333").s().p("AAFApIAAghIgBgFQAAAAgBAAQAAgBgBAAQAAAAgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAhRIARAAIAAAjIABAAQAEgIAJAAQAFAAAEADQADAEAAAGIAAApg");
	this.shape_134.setTransform(44,319.375);

	this.shape_135 = new cjs.Shape();
	this.shape_135.graphics.f("#333333").s().p("AgRAmIAAgSQAIAEAGAAQADAAABgBQACgCAAgDQAAgBAAAAQAAgBAAgBQAAAAgBgBQAAAAgBgBIgEgFQgJgHgEgFQgEgGAAgHQAAgKAGgHQAGgGAKAAQAHAAAHADIAAASQgHgFgFAAQgEAAgBACQAAAAAAABQgBAAAAABQAAAAAAABQAAABAAAAQAAAFAHAGQAGAEAFAGQAFAGAAAJQAAAKgHAHQgHAGgKAAQgHAAgHgDg");
	this.shape_135.setTransform(38.375,319.575);

	this.shape_136 = new cjs.Shape();
	this.shape_136.graphics.f("#666666").s().p("AgUAvQgIgIgBgNIAWAAQAAAJAHAAQAHAAAAgNQAAgGgCgCQgCgDgEAAIgIAAIAAgUIAIAAQAEAAADgDQABgDAAgGQABgMgIAAQgCAAgBACQgBADAAAHIAAACIgXAAQAAgJABgFQACgFAEgFQADgFAGgDQAGgDAFAAQAMAAAIAJQAIAJAAANQAAAPgMAIQAOAHAAATQAAAIgEAHQgDAHgHAEQgGADgJAAQgMAAgJgIg");
	this.shape_136.setTransform(118.05,36.025);

	this.shape_137 = new cjs.Shape();
	this.shape_137.graphics.f("#666666").s().p("AgJAJQgDgEAAgFQAAgFADgDQAEgEAFAAQAFAAAEAEQAEADAAAFQAAAFgEAEQgEAEgFAAQgFAAgEgEg");
	this.shape_137.setTransform(111.75,40.2);

	this.shape_138 = new cjs.Shape();
	this.shape_138.graphics.f("#666666").s().p("AgEA0IAAhRIgNAAIAAgWIAjAAIAABng");
	this.shape_138.setTransform(104.925,36.025);

	this.shape_139 = new cjs.Shape();
	this.shape_139.graphics.f("#666666").s().p("AgIAkIgXhHIAXAAIAIAmIAAAAIAJgmIAWAAIgWBHg");
	this.shape_139.setTransform(97.95,37.65);

	this.shape_140 = new cjs.Shape();
	this.shape_140.graphics.f("#666666").s().p("AgWAdQgJgKAAgSQABgRAHgLQAJgLAOABQAQgBAHALQAIALAAARQABASgJAKQgJAKgOgBQgOABgIgKgAgGgNQgCAEAAAJQAAATAIAAQAEgBADgEQACgEAAgKQAAgJgCgEQgDgEgEAAQgEAAgCAEg");
	this.shape_140.setTransform(86.7,37.65);

	this.shape_141 = new cjs.Shape();
	this.shape_141.graphics.f("#666666").s().p("AgVAlIAAhHIAWAAIAAAMQAIgOAJAAIADABIAAAWIgHgBQgNAAAAAQIAAAjg");
	this.shape_141.setTransform(80.4,37.55);

	this.shape_142 = new cjs.Shape();
	this.shape_142.graphics.f("#666666").s().p("AgTAzIAJgfIgWhGIAWAAIAGATIAEATIADgNIAIgZIAWAAIgeBlg");
	this.shape_142.setTransform(73.7,39.125);

	this.shape_143 = new cjs.Shape();
	this.shape_143.graphics.f("#666666").s().p("AgfA0IAAhlIAXAAIAAAKQAIgMAJAAQAKAAAHALQAFAKAAASQABAQgHAKQgGALgKAAQgJAAgIgMIAAAngAgIgNQABASAHAAQAJAAAAgSQAAgSgJAAQgHAAgBASg");
	this.shape_143.setTransform(66.55,39.025);

	this.shape_144 = new cjs.Shape();
	this.shape_144.graphics.f("#666666").s().p("AgYAyIAAgYQAMAHAHAAQAFAAABgDQADgCAAgEQAAgEgCgCQgCgDgEgEQgNgJgFgHQgGgIAAgKQAAgOAJgIQAIgJANAAQAKAAAKAEIAAAYQgLgGgGAAQgFAAgBACQgDACAAAEQAAAHALAIQAHAFAHAHQAIAJAAAMQAAANgKAJQgJAJgOAAQgKAAgKgFg");
	this.shape_144.setTransform(58.925,36.025);

	this.shape_145 = new cjs.Shape();
	this.shape_145.graphics.f("#666666").s().p("AgVAcQgHgKgBgSQABgRAHgKQAJgLAMABQAIAAAHAEQAIAFADAJQADAIABAQIglAAQAAARAIgBQADAAABgCQADgCAAgDIAUAAQgGAZgWgBQgMAAgJgKgAgFgRQgCAEAAAHIAPAAQAAgHgCgEQgCgEgDAAQgEAAgCAEg");
	this.shape_145.setTransform(51.75,37.65);

	this.shape_146 = new cjs.Shape();
	this.shape_146.graphics.f("#666666").s().p("AgKA3IAAhtIAVAAIAABtg");
	this.shape_146.setTransform(46.075,35.75);

	this.shape_147 = new cjs.Shape();
	this.shape_147.graphics.f("#666666").s().p("AgSAvQgKgGgCgMIAVAAQADAGAFAAQADAAADgEQAEgDAAgFIAAgLQgHAKgIAAQgLAAgHgKQgGgJgBgRQABgRAGgKQAGgKALAAQAIAAAIAKIAAgIIAWAAIAABCQABAJgEAIQgDAIgIAFQgJAFgIAAQgKAAgIgFgAgGgbQgCAEAAAHQAAATAIAAQAJAAAAgRQAAgSgJAAQgDAAgDAFg");
	this.shape_147.setTransform(39.8,39.025);

	this.shape_148 = new cjs.Shape();
	this.shape_148.graphics.f("#666666").s().p("AgSAvQgKgGgCgMIAVAAQADAGAFAAQADAAAEgEQADgDAAgFIAAgLQgHAKgIAAQgMAAgGgKQgHgJABgRQgBgRAHgKQAGgKALAAQAIAAAHAKIAAgIIAYAAIAABCQAAAJgEAIQgDAIgIAFQgJAFgIAAQgKAAgIgFgAgGgbQgCAEgBAHQAAATAJAAQAJAAAAgRQAAgSgJAAQgEAAgCAFg");
	this.shape_148.setTransform(32,39.025);

	this.shape_149 = new cjs.Shape();
	this.shape_149.graphics.f("#666666").s().p("AgVAdQgHgJAAgNIAAgrIAXAAIAAAtQAAAEABACQABABAAAAQABABAAAAQABAAAAAAQABAAAAAAQAGAAAAgJIAAgsIAXAAIAAApQAAAPgHAJQgIAIgOAAQgOAAgHgIg");
	this.shape_149.setTransform(24.475,37.775);

	this.shape_150 = new cjs.Shape();
	this.shape_150.graphics.f("#666666").s().p("AgUAxIAAgXQAHAEADAAQAJAAAAgLIAAhIIAWAAIAABKQABAPgIAJQgIAJgLAAQgIAAgHgFg");
	this.shape_150.setTransform(17.5,36.175);

	this.shape_151 = new cjs.Shape();
	this.shape_151.graphics.f().s("#666666").ss(1,1,1,3,true).p("A/WkvMA+tAAAIAAJfMg+tAAAg");
	this.shape_151.setTransform(62.2948,271.8129,0.274,6.7383);

	this.shape_152 = new cjs.Shape();
	this.shape_152.graphics.f("#F7F7F7").s().p("A/WEwIAApfMA+tAAAIAAJfg");
	this.shape_152.setTransform(62.2948,271.8129,0.274,6.7383);

	this.shape_153 = new cjs.Shape();
	this.shape_153.graphics.f().s("rgba(255,255,255,0.741)").ss(0.1,1,1,3,true).p("AABADIgBAAIAAgF");
	this.shape_153.setTransform(122.975,451.25);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[{t:this.shape_153},{t:this.shape_152},{t:this.shape_151},{t:this.shape_150},{t:this.shape_149},{t:this.shape_148},{t:this.shape_147},{t:this.shape_146},{t:this.shape_145},{t:this.shape_144},{t:this.shape_143},{t:this.shape_142},{t:this.shape_141},{t:this.shape_140},{t:this.shape_139},{t:this.shape_138},{t:this.shape_137},{t:this.shape_136},{t:this.shape_135},{t:this.shape_134},{t:this.shape_133},{t:this.shape_132},{t:this.shape_131},{t:this.shape_130},{t:this.shape_129},{t:this.shape_128},{t:this.shape_127},{t:this.shape_126},{t:this.shape_125},{t:this.shape_124},{t:this.shape_123},{t:this.shape_122},{t:this.shape_121},{t:this.shape_120},{t:this.shape_119},{t:this.shape_118},{t:this.shape_117},{t:this.shape_116},{t:this.shape_115},{t:this.shape_114},{t:this.shape_113},{t:this.shape_112},{t:this.shape_111},{t:this.shape_110},{t:this.shape_109},{t:this.shape_108},{t:this.shape_107},{t:this.shape_106},{t:this.shape_105},{t:this.shape_104},{t:this.shape_103},{t:this.shape_102},{t:this.shape_101},{t:this.shape_100},{t:this.shape_99},{t:this.shape_98},{t:this.shape_97},{t:this.shape_96},{t:this.shape_95},{t:this.shape_94},{t:this.shape_93},{t:this.shape_92},{t:this.shape_91},{t:this.bt_right_shadow},{t:this.bt_right_bluring},{t:this.bt_right_showAxis},{t:this.bt_right_cleaning},{t:this.bt_right_color_propPath},{t:this.shape_90},{t:this.shape_89},{t:this.shape_88},{t:this.shape_87},{t:this.shape_86},{t:this.shape_85},{t:this.shape_84},{t:this.shape_83},{t:this.shape_82},{t:this.shape_81},{t:this.shape_80},{t:this.bt_right_prop_color_filter},{t:this.ColorSelector},{t:this.bt_right_axisInitdx},{t:this.bt_right_axisInitdy},{t:this.bt_right_armLength},{t:this.bt_right_propLength},{t:this.shape_79},{t:this.shape_78},{t:this.shape_77},{t:this.shape_76},{t:this.shape_75},{t:this.bt_right_clockSpeed},{t:this.bt_right_prop_setColorFilter},{t:this.infoMode,p:{x:790,font:"14px 'Tw Cen MT Condensed Extra Bold'",color:"#999999",textAlign:"right",lineHeight:17.15,lineWidth:108}},{t:this.bt_right_propPathViewMode},{t:this.bt_clean},{t:this.bt_start},{t:this.bt_pause},{t:this.bt_stop},{t:this.bt_exportImg},{t:this.bt_reset},{t:this.bt_help_show},{t:this.bt_random},{t:this.infoMode2,p:{x:663.15,color:"#999999",textAlign:"center"}},{t:this.bt_start_record},{t:this.bt_stop_record},{t:this.shape_74},{t:this.shape_73},{t:this.shape_72},{t:this.shape_71},{t:this.shape_70},{t:this.bt_GIFGrain},{t:this.credits},{t:this.bt_credits_show},{t:this.shape_69},{t:this.shape_68},{t:this.shape_67},{t:this.shape_66},{t:this.shape_65},{t:this.shape_64},{t:this.shape_63},{t:this.shape_62},{t:this.shape_61},{t:this.shape_60},{t:this.shape_59},{t:this.shape_58},{t:this.shape_57},{t:this.shape_56},{t:this.shape_55},{t:this.shape_54},{t:this.shape_53},{t:this.shape_52},{t:this.shape_51},{t:this.shape_50},{t:this.shape_49},{t:this.shape_48},{t:this.shape_47},{t:this.shape_46},{t:this.shape_45},{t:this.shape_44},{t:this.shape_43},{t:this.shape_42},{t:this.shape_41},{t:this.shape_40},{t:this.shape_39},{t:this.shape_38},{t:this.shape_37},{t:this.shape_36},{t:this.shape_35},{t:this.shape_34},{t:this.shape_33},{t:this.shape_32},{t:this.shape_31},{t:this.shape_30},{t:this.shape_29},{t:this.shape_28},{t:this.bt_right_armWay},{t:this.bt_right_propChoice},{t:this.bt_right_nbloops},{t:this.bt_right_ratio},{t:this.bt_right_armAngle},{t:this.bt_right_propAngle,p:{scaleY:0.9091,y:200}},{t:this.bt_right_color_handPath},{t:this.bt_right_handPathViewMode},{t:this.shape_27},{t:this.shape_26},{t:this.shape_25},{t:this.shape_24},{t:this.shape_23},{t:this.shape_22},{t:this.shape_21},{t:this.shape_20},{t:this.shape_19},{t:this.shape_18},{t:this.shape_17},{t:this.shape_16},{t:this.shape_15},{t:this.shape_14},{t:this.shape_13},{t:this.shape_12},{t:this.shape_11},{t:this.shape_10},{t:this.shape_9},{t:this.shape_8},{t:this.bt_color_background},{t:this.bt_scale},{t:this.bt_speed},{t:this.bt_cleaning},{t:this.shape_7},{t:this.shape_6},{t:this.shape_5},{t:this.shape_4},{t:this.shape_3},{t:this.shape_2},{t:this.shape_1},{t:this.shape}]}).to({state:[{t:this.shape_153},{t:this.shape_152},{t:this.shape_151},{t:this.shape_150},{t:this.shape_149},{t:this.shape_148},{t:this.shape_147},{t:this.shape_146},{t:this.shape_145},{t:this.shape_144},{t:this.shape_143},{t:this.shape_142},{t:this.shape_141},{t:this.shape_140},{t:this.shape_139},{t:this.shape_138},{t:this.shape_137},{t:this.shape_136},{t:this.shape_135},{t:this.shape_134},{t:this.shape_133},{t:this.shape_132},{t:this.shape_131},{t:this.shape_130},{t:this.shape_129},{t:this.shape_128},{t:this.shape_127},{t:this.shape_126},{t:this.shape_125},{t:this.shape_124},{t:this.shape_123},{t:this.shape_122},{t:this.shape_121},{t:this.shape_120},{t:this.shape_119},{t:this.shape_118},{t:this.shape_117},{t:this.shape_116},{t:this.shape_115},{t:this.shape_114},{t:this.shape_113},{t:this.shape_112},{t:this.shape_111},{t:this.shape_110},{t:this.shape_109},{t:this.shape_108},{t:this.shape_107},{t:this.shape_106},{t:this.shape_105},{t:this.shape_104},{t:this.shape_103},{t:this.shape_102},{t:this.shape_101},{t:this.shape_100},{t:this.shape_99},{t:this.shape_98},{t:this.shape_97},{t:this.shape_96},{t:this.shape_95},{t:this.shape_94},{t:this.shape_93},{t:this.shape_92},{t:this.shape_91},{t:this.bt_right_shadow},{t:this.bt_right_bluring},{t:this.bt_right_showAxis},{t:this.bt_right_cleaning},{t:this.bt_right_color_propPath},{t:this.shape_90},{t:this.shape_89},{t:this.shape_88},{t:this.shape_87},{t:this.shape_86},{t:this.shape_85},{t:this.shape_84},{t:this.shape_83},{t:this.shape_82},{t:this.shape_81},{t:this.shape_80},{t:this.bt_right_prop_color_filter},{t:this.ColorSelector},{t:this.bt_right_axisInitdx},{t:this.bt_right_axisInitdy},{t:this.bt_right_armLength},{t:this.bt_right_propLength},{t:this.shape_79},{t:this.shape_78},{t:this.shape_77},{t:this.shape_76},{t:this.shape_75},{t:this.bt_right_clockSpeed},{t:this.bt_right_prop_setColorFilter},{t:this.infoMode,p:{x:684,font:"10px 'Tw Cen MT Condensed Extra Bold'",color:"#000000",textAlign:"",lineHeight:13.9,lineWidth:105}},{t:this.bt_right_propPathViewMode},{t:this.bt_clean},{t:this.bt_start},{t:this.bt_pause},{t:this.bt_stop},{t:this.bt_exportImg},{t:this.bt_reset},{t:this.bt_help_show},{t:this.bt_random},{t:this.infoMode2,p:{x:631.3,color:"#000000",textAlign:""}},{t:this.bt_start_record},{t:this.bt_stop_record},{t:this.shape_74},{t:this.shape_73},{t:this.shape_72},{t:this.shape_71},{t:this.shape_70},{t:this.bt_GIFGrain},{t:this.credits},{t:this.bt_credits_show},{t:this.shape_69},{t:this.shape_68},{t:this.shape_67},{t:this.shape_66},{t:this.shape_65},{t:this.shape_64},{t:this.shape_63},{t:this.shape_62},{t:this.shape_61},{t:this.shape_60},{t:this.shape_59},{t:this.shape_58},{t:this.shape_57},{t:this.shape_56},{t:this.shape_55},{t:this.shape_54},{t:this.shape_53},{t:this.shape_52},{t:this.shape_51},{t:this.shape_50},{t:this.shape_49},{t:this.shape_48},{t:this.shape_47},{t:this.shape_46},{t:this.shape_45},{t:this.shape_44},{t:this.shape_43},{t:this.shape_42},{t:this.shape_41},{t:this.shape_40},{t:this.shape_39},{t:this.shape_38},{t:this.shape_37},{t:this.shape_36},{t:this.shape_35},{t:this.shape_34},{t:this.shape_33},{t:this.shape_32},{t:this.shape_31},{t:this.shape_30},{t:this.shape_29},{t:this.shape_28},{t:this.bt_right_armWay},{t:this.bt_right_propChoice},{t:this.bt_right_nbloops},{t:this.bt_right_ratio},{t:this.bt_right_armAngle},{t:this.bt_right_propAngle,p:{scaleY:0.6818,y:197.45}},{t:this.bt_right_color_handPath},{t:this.bt_right_handPathViewMode},{t:this.shape_27},{t:this.shape_26},{t:this.shape_25},{t:this.shape_24},{t:this.shape_23},{t:this.shape_22},{t:this.shape_21},{t:this.shape_20},{t:this.shape_19},{t:this.shape_18},{t:this.shape_17},{t:this.shape_16},{t:this.shape_15},{t:this.shape_14},{t:this.shape_13},{t:this.shape_12},{t:this.shape_11},{t:this.shape_10},{t:this.shape_9},{t:this.shape_8},{t:this.bt_color_background},{t:this.bt_scale},{t:this.bt_speed},{t:this.bt_cleaning},{t:this.shape_7},{t:this.shape_6},{t:this.shape_5},{t:this.shape_4},{t:this.shape_3},{t:this.shape_2},{t:this.shape_1},{t:this.shape}]},1).wait(22));

	// gui
	this.bt_exportXML = new lib.bt_exportXML();
	this.bt_exportXML.name = "bt_exportXML";
	this.bt_exportXML.setTransform(611,563.5,1,1,0,0,0,16,16);

	this.bt_left_prop_setColorFilter = new lib.an_Checkbox({'id': 'bt_left_prop_setColorFilter', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_left_prop_setColorFilter.name = "bt_left_prop_setColorFilter";
	this.bt_left_prop_setColorFilter.setTransform(817.8,302.75,1,1,0,0,0,50,11);

	this.bt_left_shadow = new lib.an_Checkbox({'id': 'bt_left_shadow', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_left_shadow.name = "bt_left_shadow";
	this.bt_left_shadow.setTransform(798.6,321.35,1,1,0,0,0,50,11);

	this.bt_left_clockSpeed = new lib.Slider();
	this.bt_left_clockSpeed.name = "bt_left_clockSpeed";
	this.bt_left_clockSpeed.setTransform(754.4,427.25,1,1,0,0,0,21.5,0.3);

	this.shape_154 = new cjs.Shape();
	this.shape_154.graphics.f("#333333").s().p("AAFApIgLgaIgBAAIAAAaIgRAAIAAhRIARAAIAAAvIABAAIAKgTIAVAAIgSAXIASAeg");
	this.shape_154.setTransform(723.075,423.375);

	this.shape_155 = new cjs.Shape();
	this.shape_155.graphics.f("#333333").s().p("AgKAVQgFgIAAgNQAAgMAFgIQAGgIAIAAQAGAAAGAFIAAAOQgDgCgDAAQgEAAgDADQgCAEAAAEQAAAGACADQADAEAEAAQACAAAEgCIAAAOQgGAEgGAAQgIAAgGgIg");
	this.shape_155.setTransform(717.775,424.775);

	this.shape_156 = new cjs.Shape();
	this.shape_156.graphics.f("#333333").s().p("AgQAWQgGgIgBgNQAAgOAHgHQAFgIALAAQALAAAHAIQAFAHAAAOQAAANgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgCAEABAGQAAANAFAAQADABACgDQABgEAAgHQAAgGgBgEQgBgDgEAAQgCAAgCADg");
	this.shape_156.setTransform(712.9,424.8);

	this.shape_157 = new cjs.Shape();
	this.shape_157.graphics.f("#333333").s().p("AgIApIAAhRIAQAAIAABRg");
	this.shape_157.setTransform(708.45,423.375);

	this.shape_158 = new cjs.Shape();
	this.shape_158.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_158.setTransform(704.175,423.575);

	this.bt_left_propLength = new lib.Slider();
	this.bt_left_propLength.name = "bt_left_propLength";
	this.bt_left_propLength.setTransform(754.8,457.15,1,1,0,0,0,21.5,0.3);

	this.bt_left_armLength = new lib.Slider();
	this.bt_left_armLength.name = "bt_left_armLength";
	this.bt_left_armLength.setTransform(754.4,442.45,1,1,0,0,0,21.5,0.3);

	this.bt_left_axisInitdy = new lib.Slider();
	this.bt_left_axisInitdy.name = "bt_left_axisInitdy";
	this.bt_left_axisInitdy.setTransform(754.8,411.3,1,1,0,0,0,21.5,0.3);

	this.bt_left_axisInitdx = new lib.Slider();
	this.bt_left_axisInitdx.name = "bt_left_axisInitdx";
	this.bt_left_axisInitdx.setTransform(754.8,395.4,1,1,0,0,0,21.5,0.3);

	this.bt_left_handPathViewMode = new lib.an_ComboBox({'id': 'bt_left_handPathViewMode', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 3, None, 0, Comet, 1, Path, 2', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_left_handPathViewMode.name = "bt_left_handPathViewMode";
	this.bt_left_handPathViewMode.setTransform(751.45,236.7,0.65,0.9091,0,0,0,50.1,11.1);

	this.bt_left_propPathViewMode = new lib.an_ComboBox({'id': 'bt_left_propPathViewMode', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 6, None, 0, Comet, 1, Path, 2, Prop, 3, Path+CometProp, 4, Path+Prop, 5', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_left_propPathViewMode.name = "bt_left_propPathViewMode";
	this.bt_left_propPathViewMode.setTransform(752,278.05,0.65,0.9091,0,0,0,50.1,11);

	this.bt_left_prop_color_filter = new lib.ColorSelectorShow();
	this.bt_left_prop_color_filter.name = "bt_left_prop_color_filter";
	this.bt_left_prop_color_filter.setTransform(760.3,300.3,1,1,0,0,0,0.6,-0.1);

	this.shape_159 = new cjs.Shape();
	this.shape_159.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_159.setTransform(744.3,301.225);

	this.shape_160 = new cjs.Shape();
	this.shape_160.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAFAEQAGAEACAGQADAGAAAMIgcAAQABAMAFAAIAEgBIADgEIANAAQgDASgRAAQgJAAgGgIgAgEgMQgBACAAAGIAMAAQgBgFgCgDQAAgBAAAAQgBgBAAAAQgBAAAAgBQgBAAgBAAQgCAAgCADg");
	this.shape_160.setTransform(739.3,301.275);

	this.shape_161 = new cjs.Shape();
	this.shape_161.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_161.setTransform(734.825,300.575);

	this.shape_162 = new cjs.Shape();
	this.shape_162.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_162.setTransform(731.35,299.875);

	this.shape_163 = new cjs.Shape();
	this.shape_163.graphics.f("#333333").s().p("AgHAoIAAg1IAQAAIAAA1gAgGgXQgCgDAAgEQAAgDACgDQADgCADAAQADAAAEACQACADAAADQAAAEgCADQgEACgDAAQgDAAgDgCg");
	this.shape_163.setTransform(728.05,300.05);

	this.shape_164 = new cjs.Shape();
	this.shape_164.graphics.f("#333333").s().p("AgIApIAAgnIgHAAIAAgOIAHAAIAAgMQAAgIAEgEQAEgEAJAAIAGAAIAAARIgEAAIgCABIgBADIAAAHIAHAAIAAAOIgHAAIAAAng");
	this.shape_164.setTransform(724.7,299.875);

	this.shape_165 = new cjs.Shape();
	this.shape_165.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAGgLAHAAIADABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_165.setTransform(717.7,301.225);

	this.shape_166 = new cjs.Shape();
	this.shape_166.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgNAHgHQAFgIALAAQALAAAHAIQAFAHAAANQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgBADgBAHQABAOAFAAQADAAACgEQABgDAAgHQAAgHgBgDQgCgCgDAAQgCAAgCACg");
	this.shape_166.setTransform(712.55,301.3);

	this.shape_167 = new cjs.Shape();
	this.shape_167.graphics.f("#333333").s().p("AgIApIAAhRIAQAAIAABRg");
	this.shape_167.setTransform(708.1,299.875);

	this.shape_168 = new cjs.Shape();
	this.shape_168.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgNAHgHQAFgIALAAQALAAAHAIQAFAHAAANQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgBADgBAHQABAOAFAAQADAAACgEQACgDAAgHQAAgHgCgDQgBgCgEAAQgCAAgCACg");
	this.shape_168.setTransform(703.65,301.3);

	this.shape_169 = new cjs.Shape();
	this.shape_169.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_169.setTransform(698.225,300.075);

	this.bt_left_color_handPath = new lib.ColorSelectorShow();
	this.bt_left_color_handPath.name = "bt_left_color_handPath";
	this.bt_left_color_handPath.setTransform(760.3,216.8,1,1,0,0,0,0.6,-0.1);

	this.bt_left_color_propPath = new lib.ColorSelectorShow();
	this.bt_left_color_propPath.name = "bt_left_color_propPath";
	this.bt_left_color_propPath.setTransform(760.85,258.15,1,1,0,0,0,0.6,-0.1);

	this.bt_left_cleaning = new lib.an_Checkbox({'id': 'bt_left_cleaning', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_left_cleaning.name = "bt_left_cleaning";
	this.bt_left_cleaning.setTransform(798.6,378.15,1,1,0,0,0,50,11);

	this.bt_left_showAxis = new lib.an_Checkbox({'id': 'bt_left_showAxis', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_left_showAxis.name = "bt_left_showAxis";
	this.bt_left_showAxis.setTransform(798.6,359.15,1,1,0,0,0,50,11);

	this.bt_left_bluring = new lib.an_Checkbox({'id': 'bt_left_bluring', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_left_bluring.name = "bt_left_bluring";
	this.bt_left_bluring.setTransform(798.6,340.5,1,1,0,0,0,50,11);

	this.bt_left_propAngle = new lib.an_TextInput({'id': 'bt_left_propAngle', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_left_propAngle.name = "bt_left_propAngle";
	this.bt_left_propAngle.setTransform(767.9,197.1,0.3,0.6818,0,0,0,50,11.1);

	this.shape_170 = new cjs.Shape();
	this.shape_170.graphics.f("#333333").s().p("AgIAnIAAgkIgVgpIAUAAIAJAaIAJgaIAVAAIgVApIAAAkg");
	this.shape_170.setTransform(723.225,409.55);

	this.shape_171 = new cjs.Shape();
	this.shape_171.graphics.f("#333333").s().p("AAKAnIgKgYIAAAAIgCAHIgIARIgTAAIATgnIgRgmIAUAAIAHAVIAAAAIACgGIAGgPIAUAAIgSAlIAUAog");
	this.shape_171.setTransform(723.25,393.5);

	this.shape_172 = new cjs.Shape();
	this.shape_172.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEADAAQADAAADgDQABgCAAgEIAAgIQgEAIgGAAQgJAAgFgIQgEgHAAgMQgBgNAFgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIASAAIAAAxQgBAHgCAGQgDAGgFADQgHAEgGAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAGAAAAgMQAAgNgGAAQgCAAgCADg");
	this.shape_172.setTransform(743.2,378.325);

	this.shape_173 = new cjs.Shape();
	this.shape_173.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAGgJAIAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_173.setTransform(737.5,377.225);

	this.shape_174 = new cjs.Shape();
	this.shape_174.graphics.f("#333333").s().p("AgHAnIAAg1IAQAAIAAA1gAgGgXQgCgDAAgEQAAgEACgCQADgDADAAQADAAAEADQACACAAAEQAAAEgCADQgEACgDAAQgDAAgDgCg");
	this.shape_174.setTransform(732.9,376.05);

	this.shape_175 = new cjs.Shape();
	this.shape_175.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_175.setTransform(728.35,377.225);

	this.shape_176 = new cjs.Shape();
	this.shape_176.graphics.f("#333333").s().p("AgSAVQgFgIAAgNQAAgNAFgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAGAAABgNQgBgNgGAAQgGAAAAANg");
	this.shape_176.setTransform(722.3,377.325);

	this.shape_177 = new cjs.Shape();
	this.shape_177.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEADAGQACAGAAAMIgbAAQAAAMAGAAIADgBIACgEIAPAAQgFASgQAAQgJAAgGgIgAgEgMQgBACAAAGIALAAQAAgFgCgDQAAgBAAAAQAAgBgBAAQAAAAgBgBQgBAAAAAAQgDAAgCADg");
	this.shape_177.setTransform(716.85,377.275);

	this.shape_178 = new cjs.Shape();
	this.shape_178.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_178.setTransform(712.55,375.875);

	this.shape_179 = new cjs.Shape();
	this.shape_179.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_179.setTransform(708.275,376.075);

	this.shape_180 = new cjs.Shape();
	this.shape_180.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEACAGQADAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_180.setTransform(743.65,199.025);

	this.shape_181 = new cjs.Shape();
	this.shape_181.graphics.f("#333333").s().p("AgHApIAAhRIAPAAIAABRg");
	this.shape_181.setTransform(739.35,197.625);

	this.shape_182 = new cjs.Shape();
	this.shape_182.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEAEAAQACAAACgDQACgCAAgEIAAgIQgEAIgHAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIARAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAgBgMQABgNgHAAQgCAAgCADg");
	this.shape_182.setTransform(734.6,200.075);

	this.shape_183 = new cjs.Shape();
	this.shape_183.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_183.setTransform(728.9,198.975);

	this.shape_184 = new cjs.Shape();
	this.shape_184.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgRIAAAAQgBARgEAQg");
	this.shape_184.setTransform(722.775,197.85);

	this.shape_185 = new cjs.Shape();
	this.shape_185.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIABANQgBAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_185.setTransform(713.5,200.075);

	this.shape_186 = new cjs.Shape();
	this.shape_186.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgBADAAAHQAAAOAFAAQADAAACgEQABgDAAgHQAAgHgBgDQgCgCgDAAQgCAAgCACg");
	this.shape_186.setTransform(707.6,199.05);

	this.shape_187 = new cjs.Shape();
	this.shape_187.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAGgLAIAAIACABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_187.setTransform(702.8,198.975);

	this.shape_188 = new cjs.Shape();
	this.shape_188.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_188.setTransform(697.475,197.85);

	this.shape_189 = new cjs.Shape();
	this.shape_189.graphics.f("#333333").s().p("AgTAWIAFgMQAJAFAEAAQAAAAABAAQAAAAAAAAQAAAAABgBQAAAAAAAAQABAAAAgBQAAAAABAAQAAgBAAAAQAAAAAAgBIgBgCIgIgEQgGgDgDgDQgCgDgBgGQABgHAFgFQAGgGAGAAQAIAAAMAHIgGAMQgIgFgFAAQgDAAAAAEIACADIAFACQAHADAEADQADADAAAGQAAAIgFAGQgGAFgIAAQgJAAgKgHg");
	this.shape_189.setTransform(743.9,358.525);

	this.shape_190 = new cjs.Shape();
	this.shape_190.graphics.f("#333333").s().p("AgIAoIAAg1IARAAIAAA1gAgGgXQgCgDAAgEQAAgDACgDQAEgCACgBQAEABADACQACADAAADQAAAEgCADQgDACgEAAQgCABgEgDg");
	this.shape_190.setTransform(739.85,357.3);

	this.shape_191 = new cjs.Shape();
	this.shape_191.graphics.f("#333333").s().p("AAIAbIgIgSIgCAJIgFAJIgTAAIASgbIgSgaIATAAIAHARQABgEAHgNIATAAIgRAaIARAbg");
	this.shape_191.setTransform(735.25,358.55);

	this.shape_192 = new cjs.Shape();
	this.shape_192.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgQIAAAAQgBAQgEAQg");
	this.shape_192.setTransform(729.175,357.35);

	this.shape_193 = new cjs.Shape();
	this.shape_193.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_193.setTransform(723.5,454.575);

	this.shape_194 = new cjs.Shape();
	this.shape_194.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAFAEQAGAEACAGQADAGAAAMIgcAAQABAMAFAAIAFgBIACgEIANAAQgEASgQAAQgJAAgGgIgAgDgMQgCACAAAGIAMAAQgBgFgBgDQgBgBAAAAQAAgBgBAAQgBAAAAgBQgBAAgBAAQgCAAgBADg");
	this.shape_194.setTransform(717.9,454.625);

	this.shape_195 = new cjs.Shape();
	this.shape_195.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_195.setTransform(713.175,453.45);

	this.shape_196 = new cjs.Shape();
	this.shape_196.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIAAANQAAAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_196.setTransform(704.7,455.675);

	this.shape_197 = new cjs.Shape();
	this.shape_197.graphics.f("#333333").s().p("AgQAWQgHgIAAgOQABgMAFgIQAHgIAKAAQALAAAHAIQAFAIABAMQgBAOgFAIQgHAHgLAAQgKAAgGgHgAgEgJQgBACgBAHQABAOAFAAQADAAACgEQACgDAAgHQAAgHgCgCQgBgDgEAAQgCAAgCADg");
	this.shape_197.setTransform(698.8,454.65);

	this.shape_198 = new cjs.Shape();
	this.shape_198.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_198.setTransform(694,454.575);

	this.shape_199 = new cjs.Shape();
	this.shape_199.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_199.setTransform(688.675,453.45);

	this.shape_200 = new cjs.Shape();
	this.shape_200.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_200.setTransform(723.5,439.925);

	this.shape_201 = new cjs.Shape();
	this.shape_201.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAFAEQAGAEACAGQADAGAAAMIgcAAQABAMAFAAIAFgBIACgEIANAAQgEASgQAAQgJAAgGgIgAgDgMQgCACAAAGIAMAAQgBgFgBgDQgBgBAAAAQAAgBgBAAQgBAAAAgBQgBAAgBAAQgCAAgBADg");
	this.shape_201.setTransform(717.9,439.975);

	this.shape_202 = new cjs.Shape();
	this.shape_202.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_202.setTransform(713.175,438.8);

	this.shape_203 = new cjs.Shape();
	this.shape_203.graphics.f("#333333").s().p("AASAcIAAgfQAAgHgFAAQgFAAAAAHIAAAfIgQAAIAAggQAAgBAAAAQAAgBAAAAQAAgBgBAAQAAgBAAgBQgBAAAAAAQAAgBgBAAQAAAAgBAAQAAgBgBABQAAgBgBABQAAAAgBAAQAAAAAAABQgBAAAAAAQgCACAAAEIAAAfIgRAAIAAg1IARAAIAAAGQAIgIAHAAQAIAAADAJQAEgEADgDQAEgCAFAAQAMAAAAARIAAAmg");
	this.shape_203.setTransform(703.225,439.9);

	this.shape_204 = new cjs.Shape();
	this.shape_204.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_204.setTransform(696.9,439.925);

	this.shape_205 = new cjs.Shape();
	this.shape_205.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgQIAAAAQgBAQgEAQg");
	this.shape_205.setTransform(691.375,438.8);

	this.shape_206 = new cjs.Shape();
	this.shape_206.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIAAANQAAAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_206.setTransform(743.75,260.175);

	this.shape_207 = new cjs.Shape();
	this.shape_207.graphics.f("#333333").s().p("AgQAVQgGgHgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBADgBAGQABANAFAAQADAAACgDQACgCAAgIQAAgGgCgDQgBgDgEgBQgCABgCADg");
	this.shape_207.setTransform(737.85,259.15);

	this.shape_208 = new cjs.Shape();
	this.shape_208.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_208.setTransform(733.05,259.075);

	this.shape_209 = new cjs.Shape();
	this.shape_209.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_209.setTransform(727.725,257.95);

	this.shape_210 = new cjs.Shape();
	this.shape_210.graphics.f("#333333").s().p("AAFApIAAghIgBgFQAAAAgBAAQAAgBgBAAQAAAAgBAAQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAhRIARAAIAAAjIABAAQAEgIAJAAQAFAAAEADQADAEAAAGIAAApg");
	this.shape_210.setTransform(743.4,214.925);

	this.shape_211 = new cjs.Shape();
	this.shape_211.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_211.setTransform(738.625,215.625);

	this.shape_212 = new cjs.Shape();
	this.shape_212.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAEgIAIAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgRAAIAAgHIAAAAQgDAEgDACQgCADgEAAQgIAAgEgIgAgGAAQAAANAGAAQAHAAgBgNQABgNgHAAQgGAAAAANg");
	this.shape_212.setTransform(733.7,216.375);

	this.shape_213 = new cjs.Shape();
	this.shape_213.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAGQAHAHAAALQAAALgHAGQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_213.setTransform(728.025,215.15);

	this.shape_214 = new cjs.Shape();
	this.shape_214.graphics.f("#333333").s().p("AgSAiQgFgIABgNQgBgNAFgHQAFgHAIAAQAGAAAFAIIAAgjIASAAIAABRIgSAAIAAgHQgFAJgHAAQgIAAgEgIgAgFAOQAAAGABADQACAEACAAQADAAACgEQABgDAAgHQAAgNgGAAQgGAAABAOg");
	this.shape_214.setTransform(718.45,215.025);

	this.shape_215 = new cjs.Shape();
	this.shape_215.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAGgJAIAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_215.setTransform(712.75,216.275);

	this.shape_216 = new cjs.Shape();
	this.shape_216.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAEgIAIAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgRAAIAAgHIAAAAQgDAEgDACQgCADgEAAQgIAAgEgIgAgGAAQAAANAGAAQAHAAgBgNQABgNgHAAQgGAAAAANg");
	this.shape_216.setTransform(706.7,216.375);

	this.shape_217 = new cjs.Shape();
	this.shape_217.graphics.f("#333333").s().p("AAIAnIAAggIgPAAIAAAgIgRAAIAAhNIARAAIAAAdIAPAAIAAgdIASAAIAABNg");
	this.shape_217.setTransform(700.4,215.15);

	this.shape_218 = new cjs.Shape();
	this.shape_218.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQACAEAFAAQACAAACgDQACgCABgEIAAgIQgGAIgGAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIABAAIAAgGIAQAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAAAgMQAAgNgHAAQgCAAgCADg");
	this.shape_218.setTransform(744.15,341.025);

	this.shape_219 = new cjs.Shape();
	this.shape_219.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAAAgBgBQAAAAAAAAQgFAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIAAAAQAFgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_219.setTransform(738.45,339.925);

	this.shape_220 = new cjs.Shape();
	this.shape_220.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgFgXQgDgDAAgEQAAgDADgDQADgCACgBQADABADACQADADAAADQAAAEgDADQgDACgDABQgCgBgDgCg");
	this.shape_220.setTransform(733.85,338.75);

	this.shape_221 = new cjs.Shape();
	this.shape_221.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAHAAIADABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_221.setTransform(730.2,339.925);

	this.shape_222 = new cjs.Shape();
	this.shape_222.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAFgLAIAAIACABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_222.setTransform(725.85,339.925);

	this.shape_223 = new cjs.Shape();
	this.shape_223.graphics.f("#333333").s().p("AgQAWQgFgHAAgKIAAggIARAAIAAAiQAAABAAAAQAAABAAAAQABABAAAAQAAABABABQAAAAAAAAQAAAAABABQAAAAABAAQAAAAAAAAQAFAAAAgHIAAghIARAAIAAAfQAAALgGAHQgGAGgKAAQgKAAgGgGg");
	this.shape_223.setTransform(720.6,340.1);

	this.shape_224 = new cjs.Shape();
	this.shape_224.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_224.setTransform(716.05,338.575);

	this.shape_225 = new cjs.Shape();
	this.shape_225.graphics.f("#333333").s().p("AgYAnIAAhNIASAAQAPAAAHAGQAHAGAAAJQAAALgKAGQAMAEAAANQAAAKgHAGQgIAGgKAAgAgGAYQAGgBADgCQAEgCAAgEQgBgIgLAAIgBAAgAgGgHQALABAAgJQAAgEgDgCQgCgCgGAAg");
	this.shape_225.setTransform(711.5,338.8);

	this.shape_226 = new cjs.Shape();
	this.shape_226.graphics.f("#333333").s().p("AAHAbIgHgcIgGAcIgNAAIgRg1IARAAIAHAdIAGgdIANAAIAGAdIAAAAIACgIIAFgVIARAAIgRA1g");
	this.shape_226.setTransform(742.425,320.45);

	this.shape_227 = new cjs.Shape();
	this.shape_227.graphics.f("#333333").s().p("AgQAVQgGgHgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBACgBAHQABAOAFAAQADgBACgDQABgDAAgHQAAgHgBgCQgCgDgDAAQgCAAgCADg");
	this.shape_227.setTransform(735.95,320.45);

	this.shape_228 = new cjs.Shape();
	this.shape_228.graphics.f("#333333").s().p("AgSAiQgFgIABgNQgBgNAFgHQAFgHAHAAQAGAAAHAIIAAgjIARAAIAABRIgSAAIAAgHQgGAJgGAAQgIAAgEgIgAgGAOQAAAGACADQACAEACAAQADAAACgEQACgDAAgHQgBgNgGAAQgGAAAAAOg");
	this.shape_228.setTransform(730.05,319.125);

	this.shape_229 = new cjs.Shape();
	this.shape_229.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAEgIAJAAQADAAACACQADACADAFIAAgHIARAAIAAA1IgRAAIAAgHIAAAAQgDAEgDACQgCADgDAAQgJAAgEgIgAgGAAQAAANAGAAQAHAAgBgNQABgNgHAAQgGAAAAANg");
	this.shape_229.setTransform(724.15,320.475);

	this.shape_230 = new cjs.Shape();
	this.shape_230.graphics.f("#333333").s().p("AAFApIAAghIgBgFQAAAAgBAAQAAgBgBAAQAAAAgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAhRIARAAIAAAjIABAAQAEgIAJAAQAGAAADADQADAEAAAGIAAApg");
	this.shape_230.setTransform(718.45,319.025);

	this.shape_231 = new cjs.Shape();
	this.shape_231.graphics.f("#333333").s().p("AgRAmIAAgSQAIAEAGAAQADAAABgBQACgCAAgDQAAgBAAAAQAAgBAAgBQAAAAgBgBQAAAAgBgBIgEgFQgJgHgEgFQgEgGAAgHQAAgKAGgHQAGgGAKAAQAHAAAHADIAAASQgHgFgFAAQgEAAgBACQAAAAAAABQgBAAAAABQAAAAAAABQAAAAAAABQAAAFAHAGQAGAEAFAGQAFAGAAAJQAAAKgHAHQgHAGgKAAQgHAAgHgDg");
	this.shape_231.setTransform(712.825,319.225);

	this.bt_target = new lib.bt_target();
	this.bt_target.name = "bt_target";
	this.bt_target.setTransform(506.45,565.5,0.9688,0.9688,0,0,0,16,16);

	this.bt_loadXMLFile = new lib.bt_loadXMLFile();
	this.bt_loadXMLFile.name = "bt_loadXMLFile";
	this.bt_loadXMLFile.setTransform(539.5,564.5,1,1,0,0,0,16,16);

	this.bt_runXML = new lib.bt_runXML();
	this.bt_runXML.name = "bt_runXML";
	this.bt_runXML.setTransform(573.5,562.5,1,1,0,0,0,16,16);

	this.instance = new lib._2handssync_grey();
	this.instance.setTransform(752,12);

	this.bt_left_armAngle = new lib.an_TextInput({'id': 'bt_left_armAngle', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_left_armAngle.name = "bt_left_armAngle";
	this.bt_left_armAngle.setTransform(767.9,179.1,0.3,0.6818,0,0,0,50,11.1);

	this.bt_left_ratio = new lib.an_TextInput({'id': 'bt_left_ratio', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_left_ratio.name = "bt_left_ratio";
	this.bt_left_ratio.setTransform(767.95,142.25,0.3,0.6818,0,0,0,50.1,11);

	this.bt_left_nbloops = new lib.an_TextInput({'id': 'bt_left_nbloops', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_left_nbloops.name = "bt_left_nbloops";
	this.bt_left_nbloops.setTransform(767.95,160.6,0.3,0.6818,0,0,0,50.1,11.1);

	this.bt_left_propChoice = new lib.an_ComboBox({'id': 'bt_left_propChoice', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 6, None, 0, Stick, 1, Staff, 2, Poï, 3, Club, 4, Hoop, 5', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_left_propChoice.name = "bt_left_propChoice";
	this.bt_left_propChoice.setTransform(753,95.5,0.6,0.9091,0,0,0,50.1,11);

	this.bt_left_armWay = new lib.an_ComboBox({'id': 'bt_left_armWay', 'label':'', 'items':'dummy, dummy, items, 2, label, 0, , , data, 0, , , 2, Out, out, In, in', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-combobox'});

	this.bt_left_armWay.name = "bt_left_armWay";
	this.bt_left_armWay.setTransform(752.95,118.6,0.6,0.9091,0,0,0,50,11);

	this.shape_232 = new cjs.Shape();
	this.shape_232.graphics.f("#333333").s().p("AgXAnIAAhLIARAAIAAAHIABAAQAFgJAHAAQAHAAAFAIQAFAIgBANQABAMgFAIQgFAIgHAAQgHAAgFgJIgBAAIAAAdgAgGgJQABANAFAAQAHAAAAgNQAAgOgHAAQgFAAgBAOg");
	this.shape_232.setTransform(714.45,97.075);

	this.shape_233 = new cjs.Shape();
	this.shape_233.graphics.f("#333333").s().p("AgQAVQgHgHABgNQAAgOAFgHQAHgIAKAAQAMAAAFAIQAHAHAAAOQAAANgHAHQgGAIgLAAQgKAAgGgIgAgEgJQgBADAAAGQgBANAGAAQADAAACgCQABgDABgIQgBgGgBgDQgCgEgDAAQgCAAgCAEg");
	this.shape_233.setTransform(708.55,96.05);

	this.shape_234 = new cjs.Shape();
	this.shape_234.graphics.f("#333333").s().p("AgPAcIAAg1IAPAAIAAAJQAGgLAHAAIADABIAAAQIgGAAQgJAAAAALIAAAbg");
	this.shape_234.setTransform(703.75,95.975);

	this.shape_235 = new cjs.Shape();
	this.shape_235.graphics.f("#333333").s().p("AgXAnIAAhNIAWAAQALAAAHAHQAHAGAAALQAAAMgHAFQgHAGgMAAIgDAAIAAAegAgFgFQAFAAADgCQADgCAAgFQAAgFgDgCQgDgCgFAAg");
	this.shape_235.setTransform(698.425,94.85);

	this.shape_236 = new cjs.Shape();
	this.shape_236.graphics.f("#333333").s().p("AgPAVQgGgIAAgNQAAgMAGgIQAGgIAJAAQAGAAAGAEQAFAEACAGQADAGAAAMIgbAAQAAAMAFAAIAFgBIABgEIAPAAQgFASgQAAQgJAAgGgIgAgDgMQgCACAAAGIALAAQAAgFgBgDQgBgBAAAAQAAgBgBAAQAAAAgBgBQgBAAgBAAQgCAAgBADg");
	this.shape_236.setTransform(743.65,180.325);

	this.shape_237 = new cjs.Shape();
	this.shape_237.graphics.f("#333333").s().p("AgHApIAAhRIAPAAIAABRg");
	this.shape_237.setTransform(739.35,178.925);

	this.shape_238 = new cjs.Shape();
	this.shape_238.graphics.f("#333333").s().p("AgOAjQgGgEgCgJIAPAAQADAEAEAAQACAAACgDQACgCAAgEIAAgIQgEAIgHAAQgIAAgEgIQgGgHAAgMQABgNAEgHQAFgIAIAAQAGAAAFAIIAAAAIAAgGIARAAIAAAxQAAAHgCAGQgDAGgGADQgFAEgHAAQgHAAgHgEgAgEgUQgCADAAAGQAAANAGAAQAHAAgBgMQABgNgHAAQgCAAgCADg");
	this.shape_238.setTransform(734.6,181.375);

	this.shape_239 = new cjs.Shape();
	this.shape_239.graphics.f("#333333").s().p("AAFAcIAAggIgBgFQAAAAgBgBQAAAAgBAAQAAgBgBAAQAAAAgBAAQgEAAAAAHIAAAgIgRAAIAAg1IARAAIAAAHIABAAQAEgJAJAAQAFAAAEAEQADAEAAAGIAAApg");
	this.shape_239.setTransform(728.9,180.275);

	this.shape_240 = new cjs.Shape();
	this.shape_240.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgQIAAAAQgBAQgEAQg");
	this.shape_240.setTransform(722.775,179.15);

	this.shape_241 = new cjs.Shape();
	this.shape_241.graphics.f("#333333").s().p("AASAcIAAgfQAAgHgFgBQgFABAAAHIAAAfIgQAAIAAggQAAgBAAAAQAAgBAAAAQAAgBgBAAQAAgBAAgBQgBAAAAAAQAAgBgBAAQAAAAgBAAQAAgBgBAAQAAAAgBABQAAAAgBAAQAAAAAAABQgBAAAAAAQgCACAAAEIAAAfIgRAAIAAg1IARAAIAAAGQAIgIAHAAQAIAAADAJQAEgEADgDQAEgCAFAAQAMAAAAARIAAAmg");
	this.shape_241.setTransform(712.025,180.25);

	this.shape_242 = new cjs.Shape();
	this.shape_242.graphics.f("#333333").s().p("AgPAcIAAg1IAQAAIAAAJQAGgLAGAAIADABIAAAQIgFAAQgKAAAAALIAAAbg");
	this.shape_242.setTransform(705.7,180.275);

	this.shape_243 = new cjs.Shape();
	this.shape_243.graphics.f("#333333").s().p("AAMAnIgDgNIgRAAIgDANIgTAAIAVhNIATAAIAVBNgAgFAMIALAAQgEgQgCgQIAAAAQgBAQgEAQg");
	this.shape_243.setTransform(700.175,179.15);

	this.shape_244 = new cjs.Shape();
	this.shape_244.graphics.f("#333333").s().p("AgOAmIAHgXIgRg0IARAAIAEAOIADAOIAAAAIACgJIAGgTIARAAIgXBLg");
	this.shape_244.setTransform(713.825,121.85);

	this.shape_245 = new cjs.Shape();
	this.shape_245.graphics.f("#333333").s().p("AgSAVQgFgIABgNQgBgNAFgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIASAAIAAA1IgRAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAGAAABgNQgBgNgGAAQgGAAAAANg");
	this.shape_245.setTransform(708,120.775);

	this.shape_246 = new cjs.Shape();
	this.shape_246.graphics.f("#333333").s().p("AAKAnIgIgjIgCgKIAAAAIgCALIgHAiIgPAAIgThNIARAAIAKAuIAJguIAOAAIAKAuIAKguIASAAIgUBNg");
	this.shape_246.setTransform(700.75,119.55);

	this.shape_247 = new cjs.Shape();
	this.shape_247.graphics.f("#333333").s().p("AgTAWIAFgMQAJAFAEAAQAAAAABAAQAAAAAAAAQAAAAABgBQAAAAAAAAQABAAAAgBQAAAAABAAQAAgBAAAAQAAAAAAgBIgBgCIgIgEQgGgDgDgDQgCgDgBgGQABgHAFgFQAGgGAGAAQAIAAAMAHIgGAMQgIgFgFAAQgDAAAAAEIACADIAFACQAHADAEADQADADAAAGQAAAIgFAGQgGAFgIAAQgJAAgKgHg");
	this.shape_247.setTransform(743.9,161.575);

	this.shape_248 = new cjs.Shape();
	this.shape_248.graphics.f("#333333").s().p("AgWAnIAAhLIARAAIAAAHIAAAAQAFgJAGAAQAJAAAEAIQAEAIABANQgBAMgEAIQgFAIgIAAQgGAAgFgJIAAAAIAAAdgAgFgJQgBANAGAAQAGAAAAgNQAAgOgGAAQgGAAABAOg");
	this.shape_248.setTransform(738.7,162.625);

	this.shape_249 = new cjs.Shape();
	this.shape_249.graphics.f("#333333").s().p("AgQAVQgGgHgBgOQAAgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgBACgBAHQABAOAFAAQADgBACgDQABgDAAgHQAAgHgBgCQgCgDgDAAQgCAAgCADg");
	this.shape_249.setTransform(732.8,161.6);

	this.shape_250 = new cjs.Shape();
	this.shape_250.graphics.f("#333333").s().p("AgQAVQgGgHAAgOQgBgMAHgIQAFgIALAAQAMAAAFAIQAHAIgBAMQABAOgHAHQgGAIgLAAQgKAAgGgIgAgEgJQgCACABAHQgBAOAGAAQADgBACgDQACgDgBgHQABgHgCgCQgCgDgDAAQgCAAgCADg");
	this.shape_250.setTransform(727.2,161.6);

	this.shape_251 = new cjs.Shape();
	this.shape_251.graphics.f("#333333").s().p("AgPAnIAAhNIARAAIAAA7IAOAAIAAASg");
	this.shape_251.setTransform(722.325,160.4);

	this.shape_252 = new cjs.Shape();
	this.shape_252.graphics.f("#333333").s().p("AgQAWQgGgIgBgOQAAgNAHgHQAFgIALAAQALAAAHAIQAFAHAAANQAAAOgFAIQgHAHgLAAQgKAAgGgHgAgEgKQgCADABAHQAAAOAFAAQADAAACgEQABgDAAgHQAAgHgBgDQgCgCgDAAQgCAAgCACg");
	this.shape_252.setTransform(743.5,142);

	this.shape_253 = new cjs.Shape();
	this.shape_253.graphics.f("#333333").s().p("AgIAoIAAg1IAQAAIAAA1gAgGgXQgCgDAAgEQAAgDACgDQADgCADAAQAEAAADACQACADAAADQAAAEgCADQgDACgEAAQgDAAgDgCg");
	this.shape_253.setTransform(739.05,140.75);

	this.shape_254 = new cjs.Shape();
	this.shape_254.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_254.setTransform(735.575,141.275);

	this.shape_255 = new cjs.Shape();
	this.shape_255.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgQAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_255.setTransform(730.65,142.025);

	this.shape_256 = new cjs.Shape();
	this.shape_256.graphics.f("#333333").s().p("AAHAnIgNgkIgBAAIAAAkIgRAAIAAhNIAUAAQALAAAIAGQAHAGAAALQAAAHgCAFQgEAEgEACIANAkgAgHgFQALAAAAgIQAAgFgDgCQgBgDgHAAg");
	this.shape_256.setTransform(724.95,140.8);

	this.bt_go_one = new lib.bt_go_one();
	this.bt_go_one.name = "bt_go_one";
	this.bt_go_one.setTransform(180.1,564.5,1,1,0,0,0,3,16);

	this.shape_257 = new cjs.Shape();
	this.shape_257.graphics.f().s("#666666").ss(1,1,1,3,true).p("EgIlggBIRLAAMAAABADIxLAAg");
	this.shape_257.setTransform(736.75,271.425);

	this.shape_258 = new cjs.Shape();
	this.shape_258.graphics.f("#F7F7F7").s().p("EgIlAgCMAAAhADIRLAAMAAABADg");
	this.shape_258.setTransform(736.75,271.425);

	this.shape_259 = new cjs.Shape();
	this.shape_259.graphics.f().s("rgba(255,255,255,0.741)").ss(0.1,1,1,3,true).p("AByAbIgDAAAhvgUIgCAAIAAgF");
	this.shape_259.setTransform(808.7,453.3);

	this.instance_1 = new lib._1hand_grey();
	this.instance_1.setTransform(752,12);

	this.bt_go_two = new lib.bt_go_two();
	this.bt_go_two.name = "bt_go_two";
	this.bt_go_two.setTransform(193.1,562.5,1,1,0,0,0,16,16);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[]}).to({state:[{t:this.shape_259},{t:this.shape_258},{t:this.shape_257},{t:this.bt_go_one},{t:this.shape_256},{t:this.shape_255},{t:this.shape_254},{t:this.shape_253},{t:this.shape_252},{t:this.shape_251},{t:this.shape_250},{t:this.shape_249},{t:this.shape_248},{t:this.shape_247},{t:this.shape_246},{t:this.shape_245},{t:this.shape_244},{t:this.shape_243},{t:this.shape_242},{t:this.shape_241},{t:this.shape_240},{t:this.shape_239},{t:this.shape_238},{t:this.shape_237},{t:this.shape_236},{t:this.shape_235},{t:this.shape_234},{t:this.shape_233},{t:this.shape_232},{t:this.bt_left_armWay},{t:this.bt_left_propChoice},{t:this.bt_left_nbloops},{t:this.bt_left_ratio},{t:this.bt_left_armAngle},{t:this.instance},{t:this.bt_runXML},{t:this.bt_loadXMLFile},{t:this.bt_target},{t:this.shape_231},{t:this.shape_230},{t:this.shape_229},{t:this.shape_228},{t:this.shape_227},{t:this.shape_226},{t:this.shape_225},{t:this.shape_224},{t:this.shape_223},{t:this.shape_222},{t:this.shape_221},{t:this.shape_220},{t:this.shape_219},{t:this.shape_218},{t:this.shape_217},{t:this.shape_216},{t:this.shape_215},{t:this.shape_214},{t:this.shape_213},{t:this.shape_212},{t:this.shape_211},{t:this.shape_210},{t:this.shape_209},{t:this.shape_208},{t:this.shape_207},{t:this.shape_206},{t:this.shape_205},{t:this.shape_204},{t:this.shape_203},{t:this.shape_202},{t:this.shape_201},{t:this.shape_200},{t:this.shape_199},{t:this.shape_198},{t:this.shape_197},{t:this.shape_196},{t:this.shape_195},{t:this.shape_194},{t:this.shape_193},{t:this.shape_192},{t:this.shape_191},{t:this.shape_190},{t:this.shape_189},{t:this.shape_188},{t:this.shape_187},{t:this.shape_186},{t:this.shape_185},{t:this.shape_184},{t:this.shape_183},{t:this.shape_182},{t:this.shape_181},{t:this.shape_180},{t:this.shape_179},{t:this.shape_178},{t:this.shape_177},{t:this.shape_176},{t:this.shape_175},{t:this.shape_174},{t:this.shape_173},{t:this.shape_172},{t:this.shape_171},{t:this.shape_170},{t:this.bt_left_propAngle},{t:this.bt_left_bluring},{t:this.bt_left_showAxis},{t:this.bt_left_cleaning},{t:this.bt_left_color_propPath},{t:this.bt_left_color_handPath},{t:this.shape_169},{t:this.shape_168},{t:this.shape_167},{t:this.shape_166},{t:this.shape_165},{t:this.shape_164},{t:this.shape_163},{t:this.shape_162},{t:this.shape_161},{t:this.shape_160},{t:this.shape_159},{t:this.bt_left_prop_color_filter},{t:this.bt_left_propPathViewMode},{t:this.bt_left_handPathViewMode},{t:this.bt_left_axisInitdx},{t:this.bt_left_axisInitdy},{t:this.bt_left_armLength},{t:this.bt_left_propLength},{t:this.shape_158},{t:this.shape_157},{t:this.shape_156},{t:this.shape_155},{t:this.shape_154},{t:this.bt_left_clockSpeed},{t:this.bt_left_shadow},{t:this.bt_left_prop_setColorFilter},{t:this.bt_exportXML}]},1).to({state:[{t:this.bt_go_two},{t:this.instance_1}]},10).wait(12));

	// actions
	this.shape_260 = new cjs.Shape();
	this.shape_260.graphics.f("#333333").s().p("AgQAVQgGgHAAgOQgBgMAHgIQAFgIALAAQALAAAHAIQAFAIAAAMQAAAOgFAHQgHAIgLAAQgKAAgGgIgAgEgJQgCADABAGQAAANAFAAQADAAACgDQABgCAAgIQAAgGgBgDQgBgDgEgBQgCABgCADg");
	this.shape_260.setTransform(73,521.05);

	this.shape_261 = new cjs.Shape();
	this.shape_261.graphics.f("#333333").s().p("AgIAnIAAg1IAQAAIAAA1gAgGgXQgCgDAAgDQAAgFACgCQADgCADAAQAEAAADACQACACAAAFQAAADgCADQgDADgEAAQgDAAgDgDg");
	this.shape_261.setTransform(68.55,519.8);

	this.shape_262 = new cjs.Shape();
	this.shape_262.graphics.f("#333333").s().p("AgIAiIAAgnIgGAAIAAgOIAGAAIAAgOIAQAAIAAAOIAHAAIAAAPIgHAAIAAAmg");
	this.shape_262.setTransform(65.075,520.325);

	this.shape_263 = new cjs.Shape();
	this.shape_263.graphics.f("#333333").s().p("AgSAVQgEgIgBgNQABgNAEgHQAFgIAHAAQAEAAACACQADACADAFIAAgHIARAAIAAA1IgQAAIAAgHIgBAAQgDAEgDACQgCADgEAAQgHAAgFgIgAgGAAQAAANAGAAQAHAAAAgNQAAgNgHAAQgGAAAAANg");
	this.shape_263.setTransform(60.15,521.075);

	this.shape_264 = new cjs.Shape();
	this.shape_264.graphics.f("#333333").s().p("AAHAnIgNgjIgBAAIAAAjIgRAAIAAhNIAUAAQALAAAIAGQAHAHAAALQAAAFgCAGQgEAEgEADIANAjgAgHgFQALAAAAgIQAAgFgDgDQgBgCgHAAg");
	this.shape_264.setTransform(54.45,519.85);

	this.shape_265 = new cjs.Shape();
	this.shape_265.graphics.f("#333333").s().p("AAFApIgLgaIgBAAIAAAaIgRAAIAAhRIARAAIAAAvIABAAIAKgTIAVAAIgSAXIASAeg");
	this.shape_265.setTransform(45.075,519.625);

	this.shape_266 = new cjs.Shape();
	this.shape_266.graphics.f("#333333").s().p("AgKAVQgFgIAAgNQAAgMAFgIQAGgIAIAAQAGAAAGAFIAAAOQgDgCgDAAQgEAAgDADQgCAEAAAEQAAAGACADQADAEAEAAQACAAAEgCIAAAOQgGAEgGAAQgIAAgGgIg");
	this.shape_266.setTransform(39.775,521.025);

	this.shape_267 = new cjs.Shape();
	this.shape_267.graphics.f("#333333").s().p("AgQAVQgHgHABgOQAAgMAFgIQAHgIAKAAQAMAAAFAIQAHAIAAAMQAAAOgHAHQgGAIgLAAQgKAAgGgIgAgEgJQgBADAAAGQgBANAGAAQADAAACgDQABgCAAgIQAAgGgBgDQgCgDgDgBQgCABgCADg");
	this.shape_267.setTransform(34.9,521.05);

	this.shape_268 = new cjs.Shape();
	this.shape_268.graphics.f("#333333").s().p("AgHApIAAhRIAQAAIAABRg");
	this.shape_268.setTransform(30.45,519.625);

	this.shape_269 = new cjs.Shape();
	this.shape_269.graphics.f("#333333").s().p("AgMAeQgJgMAAgSQAAgRAJgMQAKgLAOAAQAFAAAFABIAAATQgFgCgEAAQgHAAgFAHQgDAGAAAJQAAAKADAGQAFAHAHAAQAEAAAFgCIAAASQgFACgFAAQgOAAgKgLg");
	this.shape_269.setTransform(26.175,519.825);

	this.bt_setClockSpeedRatio = new lib.an_Checkbox({'id': 'bt_setClockSpeedRatio', 'label':'', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-checkbox'});

	this.bt_setClockSpeedRatio.name = "bt_setClockSpeedRatio";
	this.bt_setClockSpeedRatio.setTransform(144.95,512.45,1,1,0,0,0,50,11);

	this.bt_clockSpeedRatio = new lib.an_TextInput({'id': 'bt_clockSpeedRatio', 'value':'', 'disabled':false, 'visible':true, 'class':'ui-textinput'});

	this.bt_clockSpeedRatio.name = "bt_clockSpeedRatio";
	this.bt_clockSpeedRatio.setTransform(99.45,525.45,0.25,0.6818,0,0,0,50.2,11.2);

	this.timeline.addTween(cjs.Tween.get({}).to({state:[]}).to({state:[{t:this.bt_clockSpeedRatio},{t:this.bt_setClockSpeedRatio},{t:this.shape_269},{t:this.shape_268},{t:this.shape_267},{t:this.shape_266},{t:this.shape_265},{t:this.shape_264},{t:this.shape_263},{t:this.shape_262},{t:this.shape_261},{t:this.shape_260}]},1).to({state:[]},10).wait(12));

	this._renderFirstFrame();

}).prototype = p = new lib.AnMovieClip();
p.nominalBounds = new cjs.Rectangle(406.3,310.8,461.99999999999994,290.3);
// library properties:
lib.properties = {
	id: '9083A5A488D61B4199A7094AD8C71827',
	width: 800,
	height: 600,
	fps: 24,
	color: "#FFFFFF",
	opacity: 1.00,
	manifest: [
		{src:"images/_1hand.png?1595198868395", id:"_1hand"},
		{src:"images/_1hand_grey.png?1595198868395", id:"_1hand_grey"},
		{src:"images/_2handssync.png?1595198868395", id:"_2handssync"},
		{src:"images/_2handssync_grey.png?1595198868395", id:"_2handssync_grey"},
		{src:"images/clean.png?1595198868395", id:"clean"},
		{src:"images/ColorWheel.png?1595198868395", id:"ColorWheel"},
		{src:"images/creditsimg.png?1595198868395", id:"creditsimg"},
		{src:"images/help.png?1595198868395", id:"help"},
		{src:"images/info.png?1595198868395", id:"info"},
		{src:"images/pause.png?1595198868395", id:"pause"},
		{src:"images/photo.png?1595198868395", id:"photo"},
		{src:"images/play.png?1595198868395", id:"play"},
		{src:"images/reset.png?1595198868395", id:"reset"},
		{src:"images/save.png?1595198868395", id:"save"},
		{src:"images/start_record.png?1595198868395", id:"start_record"},
		{src:"images/stop.png?1595198868395", id:"stop"},
		{src:"images/stop_record.png?1595198868395", id:"stop_record"},
		{src:"images/target.png?1595198868395", id:"target"},
		{src:"images/videorandom.png?1595198868395", id:"videorandom"},
		{src:"images/videoXML.png?1595198868395", id:"videoXML"},
		{src:"images/videoXMLfile.png?1595198868395", id:"videoXMLfile"},
		{src:"components/lib/jquery-3.4.1.min.js?1595198868395", id:"lib/jquery-3.4.1.min.js"},
		{src:"components/sdk/anwidget.js?1595198868395", id:"sdk/anwidget.js"},
		{src:"components/ui/src/textinput.js?1595198868395", id:"an.TextInput"},
		{src:"components/ui/src/combobox.js?1595198868395", id:"an.ComboBox"},
		{src:"components/ui/src/checkbox.js?1595198868395", id:"an.Checkbox"}
	],
	preloads: []
};



// bootstrap callback support:

(lib.Stage = function(canvas) {
	createjs.Stage.call(this, canvas);
}).prototype = p = new createjs.Stage();

p.setAutoPlay = function(autoPlay) {
	this.tickEnabled = autoPlay;
}
p.play = function() { this.tickEnabled = true; this.getChildAt(0).gotoAndPlay(this.getTimelinePosition()) }
p.stop = function(ms) { if(ms) this.seek(ms); this.tickEnabled = false; }
p.seek = function(ms) { this.tickEnabled = true; this.getChildAt(0).gotoAndStop(lib.properties.fps * ms / 1000); }
p.getDuration = function() { return this.getChildAt(0).totalFrames / lib.properties.fps * 1000; }

p.getTimelinePosition = function() { return this.getChildAt(0).currentFrame / lib.properties.fps * 1000; }

an.bootcompsLoaded = an.bootcompsLoaded || [];
if(!an.bootstrapListeners) {
	an.bootstrapListeners=[];
}

an.bootstrapCallback=function(fnCallback) {
	an.bootstrapListeners.push(fnCallback);
	if(an.bootcompsLoaded.length > 0) {
		for(var i=0; i<an.bootcompsLoaded.length; ++i) {
			fnCallback(an.bootcompsLoaded[i]);
		}
	}
};

an.compositions = an.compositions || {};
an.compositions['9083A5A488D61B4199A7094AD8C71827'] = {
	getStage: function() { return exportRoot.stage; },
	getLibrary: function() { return lib; },
	getSpriteSheet: function() { return ss; },
	getImages: function() { return img; }
};

an.compositionLoaded = function(id) {
	an.bootcompsLoaded.push(id);
	for(var j=0; j<an.bootstrapListeners.length; j++) {
		an.bootstrapListeners[j](id);
	}
}

an.getComposition = function(id) {
	return an.compositions[id];
}


an.makeResponsive = function(isResp, respDim, isScale, scaleType, domContainers) {		
	var lastW, lastH, lastS=1;		
	window.addEventListener('resize', resizeCanvas);		
	resizeCanvas();		
	function resizeCanvas() {			
		var w = lib.properties.width, h = lib.properties.height;			
		var iw = window.innerWidth, ih=window.innerHeight;			
		var pRatio = window.devicePixelRatio || 1, xRatio=iw/w, yRatio=ih/h, sRatio=1;			
		if(isResp) {                
			if((respDim=='width'&&lastW==iw) || (respDim=='height'&&lastH==ih)) {                    
				sRatio = lastS;                
			}				
			else if(!isScale) {					
				if(iw<w || ih<h)						
					sRatio = Math.min(xRatio, yRatio);				
			}				
			else if(scaleType==1) {					
				sRatio = Math.min(xRatio, yRatio);				
			}				
			else if(scaleType==2) {					
				sRatio = Math.max(xRatio, yRatio);				
			}			
		}
		domContainers[0].width = w * pRatio * sRatio;			
		domContainers[0].height = h * pRatio * sRatio;
		domContainers.forEach(function(container) {				
			container.style.width = w * sRatio + 'px';				
			container.style.height = h * sRatio + 'px';			
		});
		stage.scaleX = pRatio*sRatio;			
		stage.scaleY = pRatio*sRatio;
		lastW = iw; lastH = ih; lastS = sRatio;            
		stage.tickOnUpdate = false;            
		stage.update();            
		stage.tickOnUpdate = true;		
	}
}
function _updateVisibility(evt) {
	var parent = this.parent;
	var detach = this.stage == null || this._off || !parent;
	while(parent) {
		if(parent.visible) {
			parent = parent.parent;
		}
		else{
			detach = true;
			break;
		}
	}
	detach = detach && this._element && this._element._attached;
	if(detach) {
		this._element.detach();
		this.dispatchEvent('detached');
		stage.removeEventListener('drawstart', this._updateVisibilityCbk);
		this._updateVisibilityCbk = false;
	}
}
function _handleDrawEnd(evt) {
	if(this._element && this._element._attached) {
		var props = this.getConcatenatedDisplayProps(this._props), mat = props.matrix;
		var tx1 = mat.decompose(); var sx = tx1.scaleX; var sy = tx1.scaleY;
		var dp = window.devicePixelRatio || 1; var w = this.nominalBounds.width * sx; var h = this.nominalBounds.height * sy;
		mat.tx/=dp;mat.ty/=dp; mat.a/=(dp*sx);mat.b/=(dp*sx);mat.c/=(dp*sy);mat.d/=(dp*sy);
		this._element.setProperty('transform-origin', this.regX + 'px ' + this.regY + 'px');
		var x = (mat.tx + this.regX*mat.a + this.regY*mat.c - this.regX);
		var y = (mat.ty + this.regX*mat.b + this.regY*mat.d - this.regY);
		var tx = 'matrix(' + mat.a + ',' + mat.b + ',' + mat.c + ',' + mat.d + ',' + x + ',' + y + ')';
		this._element.setProperty('transform', tx);
		this._element.setProperty('width', w);
		this._element.setProperty('height', h);
		this._element.update();
	}
}

function _tick(evt) {
	var stage = this.stage;
	stage&&stage.on('drawend', this._handleDrawEnd, this, true);
	if(!this._updateVisibilityCbk) {
		this._updateVisibilityCbk = stage.on('drawstart', this._updateVisibility, this, false);
	}
}
function _componentDraw(ctx) {
	if(this._element && !this._element._attached) {
		this._element.attach($('#dom_overlay_container'));
		this.dispatchEvent('attached');
	}
}
an.handleSoundStreamOnTick = function(event) {
	if(!event.paused){
		var stageChild = stage.getChildAt(0);
		if(!stageChild.paused){
			stageChild.syncStreamSounds();
		}
	}
}


})(createjs = createjs||{}, AdobeAn = AdobeAn||{});
var createjs, AdobeAn;