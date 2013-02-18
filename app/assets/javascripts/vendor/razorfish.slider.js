~function( NS ){
  NS.Slider = function Slider( params ){
    this.$evNode  = $( '<div></div>' );
    this.$node    = $( '<div class="slider"></div>' );
    this.$notches = [];

    $.extend( this, params || {} );

    this.render();
  };

  NS.Slider.prototype = {
    render : function render(){
      // create structure
      this.$node
        .append( '<div class="slider-bar"></div>' )
        .append( this.$range   = $( '<div class="slider-range"  ></div>' ) )
        .append( this.$tabs    = $( '<div class="slider-tabs"   ></div>' ) )
        .append( this.$handles = $( '<div class="slider-handles"></div>' ) )
        ;

      // calculate width of one tab
      var tabWidth = this.tabWidth = 0 | ( this.width - 2 * ( this.padding || 0 ) ) / this.tabs.length
        ,   margin =   this.margin = this.width - this.tabs.length * tabWidth >> 1
        , last;

      // add left/right margin to the tabs
      this.$tabs.css( { marginLeft: margin, marginRight: margin } );

      // append all tabs
      for( var i=0, l=this.tabs.length; i<l; i++ ){
        this.$tabs.append( last = $( '<div class="slider-tab"><div class="slider-notch"></div><span>' + this.tabs[i].text + '</span></div>' ).css( { width: tabWidth } ) );
        this.$notches.push( last.find( '.slider-notch' ) );
        last.find( 'span' ).data( 'tab', i ).bind( 'click', $.proxy( this, 'setEndpoint' ) );
      }

      // append handle(s)
      this.$handles.append(
        this.$lHandle = $( '<div class="slider-handle"></div>' )
          .data( 'handle', 'left' )
          .on  ( 'mousedown', $.proxy( this, 'handleDown' ) )
      );

      if( this.useRange ){
        this.$handles.append(
          this.$rHandle = $( '<div class="slider-handle"></div>' )
            .data( 'handle', 'right' )
            .on  ( 'mousedown', $.proxy( this, 'handleDown' ) )
        );

        this.$range.on( 'mousedown', $.proxy( this, 'rangeDown' ) );
      }

      var self = this;
      $( function(){
        // attach body event handlers
        $( 'body' )
          .on( 'mousemove', $.proxy( self, 'mouseMove' ) )
          .on( 'mouseup'  , $.proxy( self, 'mouseUp'   ) );
      } );
    }

    , setEndpoint : function setEndpoint( ev ){
      ev.preventDefault();

      var   tab = $( ev.target ).data( 'tab' )
        , fromS = Math.abs( this.minPos - tab )
        , fromE = Math.abs( this.maxPos - tab );

      this.oRange = [ this.minPos, this.maxPos ];

      if( fromE < fromS ){
        this.animateTo([ this.minPos, tab ]);
      }else{
        this.animateTo([ tab, this.maxPos ]);
      }
    }

    , setRange : function setRange( min, max ){
      this.minPos = min;
      this.maxPos = max || Infinity;

      this.$lHandle.css( { left: min = this.getTargetPos( min ) } );

      this.$rHandle
        && this.$rHandle.css( { left: max = this.getTargetPos( max ) } )
        && this.$range.css({ left: min + this.handleWidth / 2, width: max-min });

      if( max != null ){
        for( var i=0, l=this.$notches.length; i<l; i++ ){
          this.$notches[ i ][ ( ( this.minPos < i ) && ( this.maxPos > i ) ) ? 'addClass' : 'removeClass' ]( 'active' )
        }
      }

      this.trigger( 'range', [ this.minPos, this.maxPos ] );

      return this;
    }

    , animateTo : function animateTo( range ){
      var oRange = [ this.minPos, this.maxPos ]
        ,   self = this;

      this.$evNode.css({ left: 0 }).animate({ left:1 }, {
        step : function( val ){
          self.setRange( oRange[0] + ( range[0] - oRange[0] ) * val, oRange[1] + ( range[1] - oRange[1] ) * val );
        }
      } )
    }

    , getTargetPos : function getTargetPos( ix ){
      return this.margin + this.tabWidth * ix + this.tabWidth / 2 - this.handleWidth / 2;
    }

    , handleDown : function handleDown( ev ){
      ev.preventDefault();

      this.handleNm     = $( ev.target ).data( 'handle' );
      this.activeHandle = ( this.handleNm === 'right' ) ? this.$rHandle : this.$lHandle;
      this.oRange       = [ this.minPos, this.maxPos ];
      this.mouseX       = ev.pageX;
    }

    , mouseMove : function mouseMove( ev ){
      if( this.handleNm === 'range' ){ this.rangeMove( ev ); }
      if( !this.activeHandle ){ return; }
      ev.preventDefault();

      var  diff = ev.pageX - this.mouseX
        , range = this.oRange.slice();

      range[ this.handleNm === 'right' ? 1 : 0 ] += diff / this.tabWidth;

      if( this.handleNm === 'right' ){
        range[ 1 ] = Math.min( this.tabs.length - 1, Math.max( range[1], range[0] + 1 ) );
      }else{
        range[ 0 ] = Math.max( 0, Math.min( range[0], range[1] - 1 ) );
      }

      this.setRange( range[0], range[1] );
    }

    , mouseUp : function mouseUp( ev ){
      if( !this.handleNm ){ return; }

      this.animateTo([ Math.round( this.minPos ), Math.round( this.maxPos ) ]);

      delete this.activeHandle;
      delete this.handleNm;
    }

    , rangeDown : function rangeDown( ev ){
      ev.preventDefault();

      this.handleNm = 'range';
      this.oRange   = [ this.minPos, this.maxPos ];
      this.mouseX   = ev.pageX;
    }

    , rangeMove : function rangeMove( ev ){
      ev.preventDefault();

      var  diff = ev.pageX - this.mouseX
        , range = this.oRange.slice();

      range[0] += diff / this.tabWidth;
      range[1] += diff / this.tabWidth;

      if( range[0] < 0 ){
        range[1] += -range[0];
        range[0]  = 0;
      }

      if( range[1] > ( this.tabs.length - 1 ) ){
        range[0] -= range[ 1 ] - this.tabs.length + 1;
        range[1]  = this.tabs.length - 1;
      }

      this.setRange( range[0], range[1] );
    }

    ,     appendTo : function     appendTo( node ){ this.$node.appendTo    ( node ); return this; }
    ,    prependTo : function    prependTo( node ){ this.$node.prependTo   ( node ); return this; }
    ,  insertAfter : function  insertAfter( node ){ this.$node.insertAfter ( node ); return this; }
    , insertBefore : function insertBefore( node ){ this.$node.insertBefore( node ); return this; }

    , bind    : function bind   (){ this.$evNode.bind   .apply( this.$evNode, arguments ); return this; }
    , unbind  : function unbind (){ this.$evNode.unbind .apply( this.$evNode, arguments ); return this; }
    , trigger : function trigger(){ this.$evNode.trigger.apply( this.$evNode, arguments ); return this; }
    , one     : function one    (){ this.$evNode.one    .apply( this.$evNode, arguments ); return this; }
  };
}( this.Razorfish || ( this.Razorfish = {} ) );