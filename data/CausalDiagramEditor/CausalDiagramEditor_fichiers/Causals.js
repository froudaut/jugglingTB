var abc='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var Hex='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var DegToRad=Math.PI/180;
var HorizSplit=60;
var VertSplit=60;
var FontSize=14;
var NodeRadius=12;
var LineWidth=1;
var ArrowHead=8;
var BackgroundColour='#ffffff';
var NodeColour='#ffffff';
var TextColour='#000000';
var CauseColour='#999999';
var HighlightColour='#ff0000';
var BarColour='#cccccc';

var Canvas=document.createElement('canvas');
if(document.getElementsByClassName && Canvas.getContext && Canvas.getContext('2d'))
  {
    var PixelRatio=window.devicePixelRatio || 1;
    DrawCausals(document.getElementsByClassName('CausalDiagram'));
  }

function DrawCausals(e)
{
  for(var a=0;a<e.length;++a)
    {
      Draw(e[a]);
    }
}

function Draw(Span)
{
  var Input=Span.innerHTML,Canvas=document.createElement('canvas'),Ctx=Canvas.getContext('2d'),Title='',Bars,Siteswap,ThisVal,PrechacThrow,W,H,Data,Meta,Hands=[],Delay=[],ThisAngle,Offset,a,b,c,x,y=VertSplit,MaxX=HorizSplit,x1,y1,x2,y2;

  Input=Input.replace(/(^&lt;|&gt;$)/g,'');
  Input=Input.replace(/\|/g,'\n');
  Input=Input.replace(/<br[\s\/]*>/g,'\n');
  Input=Input.replace(/<\/?\w[^>]*>/g,'');
  Input=Input.replace(/ +/g,' ');
  Input=Input.replace(/^\s+/g,'');
  Input=Input.replace(/\s+$/g,'');
  Input=Input.split(/[\n\r]+/);
  Span.innerHTML='';
  Span.appendChild(Canvas);

  a=0,b=Input.length;
  while(a<b)
    {
      Input[a]=Input[a].trim();

      if(Input[a].match(/^Title\s*:\s*/i))
        {
// User specified title
          Title=Input[a].replace(/Title\s*:\s*/i,'');

          Input.splice(a,1);
          --b;
        }
      else if(Input[a].match(/^Bars?\s*:\s*/i))
        {
// Vertical bars
          Bars=Input[a].replace(/Bars?\s*:\s*/i,'');

          Input.splice(a,1);
          --b;
        }
      else
        ++a;
    }



// Convert 4 handed siteswap to prechac

  if(Input.length===1 && Input[0].match(/^[\w,]+$/))
    {
      Siteswap=Input[0].toUpperCase();
      if(Title==='')
        Title=Siteswap.replace(/,/g,'');

// Double the sequence
      Siteswap=Siteswap+Siteswap;

      Input[0]='(RL 0)';
      Input[1]='(RL 0.5)';

      a=0;
      b=Siteswap.length;
      c=0;
      while(a<b)
        {
// Get throw weight
          ThisVal=Hex.indexOf(Siteswap.charAt(a));

// Convert 4 hand siteswap value to 2 hand value
          PrechacThrow=ThisVal/2;

// If digit is odd, convert to a pass
          if(ThisVal%2===1)
            PrechacThrow+='p';

          Input[c]+=' '+PrechacThrow;

// Highlights
          if(Siteswap[a+1]===',')
            {
              Input[c]+=',';
              ++a;
            }

// Next throw will be by the other juggler
          c=(c===0)?1:0;

          ++a;
        }
    }



// Loop through input data to calculate dimensions of diagram
  for(a=0;a<Input.length;++a)
    {
      Meta=Input[a].match(/\(.*\)/);

      if(Meta && Meta[0].match(/^\(\w+(\s[\.0-9]+)?\)$/i))
        {
// (handsequence delay)
          Meta=Meta[0].toString().replace(/(\(|\))/g,'').split(' ');
          Hands[a]=(Meta[0]) ? Meta[0]:'RL';
          Delay[a]=(Meta[1]) ? Meta[1]:0;
        }
      else
        {
          Hands[a]='RL';
          Delay[a]=0;
        }

      Input[a]=Input[a].replace(/\(.*\)\s/,'');
      Data=Input[a].split(' ');

      x=HorizSplit+(Delay[a]*HorizSplit);

      for(b=0;b<Data.length;++b)
        {
// Horizontal distance of cause in pixels
          Xoffset=(Number(Data[b].replace(/[A-z,*]/g,''))-2)*HorizSplit;
// MaxX will end up as centre of last node that receives a cause
          MaxX=Math.max(MaxX,x+Xoffset);

          x=x+HorizSplit;
        }
    }

  ++MaxX;

  Canvas.width=MaxX+HorizSplit;
  Canvas.height=(Input.length+1)*(VertSplit+FontSize);

// Scale canvas for HiDPI devices
  if(PixelRatio>1)
    {
      W=Canvas.width;
      H=Canvas.height;

      Canvas.width=W*PixelRatio;
      Canvas.height=H*PixelRatio;
      Canvas.style.width=W+'px';
      Canvas.style.height=H+'px';

      Ctx.scale(PixelRatio,PixelRatio);
    }

  Ctx.fillStyle=BackgroundColour;
  Ctx.fillRect(0,0,Canvas.width,Canvas.height);
  Ctx.font=FontSize+'px sans-serif';
  Ctx.lineWidth=LineWidth;
  Ctx.textAlign='center';
  Ctx.textBaseline='middle';

// Vertical bars
  if(Bars && Bars.length>0)
    {
      Bars=Bars.replace(' ','');
      Bars=Bars.split(',');

      Ctx.strokeStyle=BarColour;

      y1=VertSplit/2;
      y2=(Input.length+0.5)*VertSplit;

      for(a=0;a<Bars.length;++a)
        {
          x=Number(Bars[a])*HorizSplit;

          Ctx.beginPath();
          Ctx.moveTo(x,y1);
          Ctx.lineTo(x,y2);
          Ctx.stroke();
        }
    }


// Loop through jugglers drawing causes

  for(a=0;a<Input.length;++a)
    {
      Data=Input[a].split(' ');

      x=HorizSplit+(Delay[a]*HorizSplit);

// Loop through throws, draw as causes
      for(b=0;b<Data.length;++b)
        {
          Ctx.strokeStyle=(Data[b].substr(-1)===',') ? HighlightColour:CauseColour;
          Data[b]=Data[b].replace(/[^\w\.]/g,'');

// Horizontal distance of cause in pixels
          Xoffset=(Number(Data[b].replace(/[A-z,]/g,''))-2)*HorizSplit;

// Causes
          if(Data[b]==='3' && (!Data[b+1] || Data[b+1][0]!=='1'))
            {
// Self NOT followed by zip
              DrawLine(Ctx,x,y,x+HorizSplit,y);
            }
          else if(Data[b]==='1')
            {
// Zip
              DrawLine(Ctx,x,y,x-HorizSplit,y);
            }
          else if(Data[b].match(/[A-z]/))
            {
// Pass
              Dest=Data[b].replace(/[0-9\.]/g,'').toUpperCase();
              if(Input.length==2 && Dest==='P')
                {
// Only 2 jugglers, has to be the other one
                  Yoffset=(a===0) ? 1:-1;
                }
              else
                {
// Multiple jugglers, will be referenced by letter
                  Yoffset=abc.indexOf(Dest)-a;
                }

// Vertical distance in pixels
              Yoffset=Yoffset*VertSplit;

              DrawLine(Ctx,x,y,x+Xoffset,y+Yoffset);
            }
          else if(Data[b]!=='2')
            {
// Self followed by zip, or 4+ self

// Source node coordinates
              x1=x;
              y1=y;

// Target node coordinates
              x2=x+Xoffset;
              y2=y;

// Calc peak halfway between nodes
              PeakX=x+(Xoffset/2);
              PeakY=(Data[b]==='3' && (!Data[b+1] || Data[b+1][0]==='1')) ? y-(3*FontSize):y-(4*FontSize);

// Angle that line will exit node
              ThisAngle=Math.atan2(y1-PeakY-180,x2-x1);

// Calc points on outside edge of node outline
              Offset=NodeRadius*Math.cos(ThisAngle);
              x1=x1+Offset;
              x2=x2-Offset;

              Offset=NodeRadius*Math.sin(ThisAngle);
              y1=y1+Offset;
              y2=y2+Offset;

// Draw arrow
// Curve
              Ctx.beginPath();
              Ctx.moveTo(x1,y1);
              Ctx.quadraticCurveTo(PeakX,PeakY,x2,y2);
              Ctx.stroke();
// Arrow head
              ThisAngle=Math.atan2(y2-PeakY,x2-PeakX);
              DrawArrow(Ctx,x2,y2,ThisAngle);
            }

          x=x+HorizSplit;
        }

// Starting letter
      Ctx.fillStyle=TextColour;
      Ctx.fillText(abc.charAt(a),HorizSplit/2,y);

// Draw all nodes up to MaxX
      Ctx.strokeStyle=CauseColour;
      x=HorizSplit+(Delay[a]*HorizSplit);
      b=0;

      while(x<MaxX)
        {
          Ctx.beginPath();
          Ctx.arc(x,y,NodeRadius,0,Math.PI*2,true);
          Ctx.closePath();
          Ctx.fillStyle=NodeColour;
          Ctx.fill();
          Ctx.stroke();

          Ctx.fillStyle=TextColour;
          Ctx.fillText(Hands[a].charAt(b%Hands[a].length),x,y);

          ++b;
          x=x+HorizSplit;
        }

      y=y+VertSplit;
    }



// Print user specified title or pattern info
  Ctx.textAlign='left';
  Ctx.fillStyle=TextColour;

  if(Title)
    {
      x=(Canvas.width/PixelRatio-Ctx.measureText(Title).width)/2;
      Ctx.fillText(Title,x,y);
    }
  else
    {
      b=0;
      for(a=0;a<Input.length;++a)
        b=Math.max(b,Ctx.measureText(abc.charAt(a)+': '+Input[a]).width);
      x=(Canvas.width/PixelRatio-b)/2;

      for(a=0;a<Input.length;++a)
        {
          Ctx.fillText(abc.charAt(a)+': '+Input[a],x,y);
          y=y+FontSize;
        }
    }
}

function DrawLine(Ctx,x1,y1,x2,y2)
{
  var ThisAngle=Math.atan2(y2-y1,x2-x1),Offset=NodeRadius*Math.cos(ThisAngle);
  x1=x1+Offset;
  x2=x2-Offset;

  Offset=NodeRadius*Math.sin(ThisAngle);
  y1=y1+Offset;
  y2=y2-Offset;

  Ctx.beginPath();
  Ctx.moveTo(x1,y1);
  Ctx.lineTo(x2,y2);
  Ctx.stroke();

  DrawArrow(Ctx,x2,y2,ThisAngle);
}

function DrawArrow(Ctx,x1,y1,ThisAngle)
{
  var a1=ThisAngle-Math.PI/6,a2=ThisAngle+Math.PI/6;
  Ctx.beginPath();
  Ctx.moveTo(x1-ArrowHead*Math.cos(a1),y1-ArrowHead*Math.sin(a1));
  Ctx.lineTo(x1,y1);
  Ctx.lineTo(x1-ArrowHead*Math.cos(a2),y1-ArrowHead*Math.sin(a2));
  Ctx.stroke();
}