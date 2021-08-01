class Siteswap{
	constructor(sequenceString){
		this.sequence = [];
		this.valid  = true;
		for (var i=0;i<sequenceString.length;i++){
			/*if number*/
			var c = sequenceString.charCodeAt(i);
			if (c >= 48 && c <= 57){
				this.sequence.push(c-48);	
			}else if(c >= 97 && c <= 122){
				this.sequence.push(c-87);
			}else{
				this.sequence.push(null);
				this.valid=false;
			}
		}
	}
	isValid(){
		if (!this.valid){
			return false
		}

		var dict = {};
		for (var i=0;i<this.sequence.length;i++){
			var itemToCheck = (this.sequence[i]+i) % this.sequence.length;
			var sum = this.sequence[i]+i
			if (dict.hasOwnProperty(itemToCheck)){
				return false;
			}
			dict[itemToCheck]=true;
		}
		return true;
	}
	ballCount(){
		if (!this.isValid){
			throw "pattern not valid";
		}
		var total = 0;
		for (var i = 0; i<this.sequence.length; i++){
			total += this.sequence[i];
		}
		return total/this.sequence.length;
	}
	maxThrow(){
		if (!this.isValid){
			throw "pattern not valid";
		}
		var maxThrow = 0;
		for (var i = 0; i< this.sequence.length; i++){
			if (this.sequence[i] > maxThrow){
				maxThrow = this.sequence[i];
			}
		}
		return maxThrow;
	}
	getSiteswapArray(){
		return this.sequence;
	}
}