$(document).ready(function(){
  // enable the 1st select for frame1
  $( 'select#pins_down_frame0_throw1', 'form#form_for_new_bowlgame').prop( 'disabled', false);

  // a jquery fn for filtering select by numeric comparison of its options ( assumed numeric) vs a given number
  // we retain only options that do not exceed number_input.
  // cf http://stackoverflow.com/questions/1447728/how-to-dynamic-filter-options-of-select-with-jquery
  jQuery.fn.filterByNumeric = function( number_input) {
      return this.each(function() {
          var select = this;
          var options = [];
          $(select).find('option').each(function() {
            if ( parseInt( $(this).val()) > number_input )  {
              $(this).addClass( 'hide');
            }
          });
      });
  };

  // - if a throw1 select is changed
  // -   note its new value
  // -   disable itself
  // -   if value 10
  // -     disable sibling throw2 select
  // -     enable next throw1 select
  // -
  // -     set cbx_pins_down_frame#{frame_number} to [ 10]
  // -  
  // -   else
  // -     enable sibling throw2 select
  // -     filter sibling throw2 select accordingly
  // -   end
  // - end
  
  // - if a throw2 select is changed
  // -   disable itself
  // -   enable next throw1 select
  // -
  // -   set cbx_pins_down_frame#{frame_number} to [ throw1 select value, throw2 select value ]
  // -
  // - end
  
  // - Above hold for frame0 to frame8
  // - For last frame9, refer below.
  
  // - throw1 select is changed
  // - note its new value
  // - disable itself
  // - if value < 10
  // -   filter sibling throw2 select accordingly
  // - end
  // - enable sibling throw2 select
  
  // - throw2 select is changed
  // - disable itself
  // - if sibling throw1 select value 10
  // -   enable sibling throw3 select
  // - else
  // -   set cbx_pins_down_frame#{frame_number} to [ throw1 select value, throw2 select value ]
  // - end
  
  // - throw3 select is changed
  // - disable itself
  // - set cbx_pins_down_frame#{frame_number} to [ throw1 select value, throw2 select value, throw3 select value ]
  
  $( "form#form_for_new_bowlgame").on( 'change', function(e) {
    const STRIKE = 10;
    var $target = $( e.target);
    var $frameno_s;
    var $val_s;
    var $frameno_i;
    var $val_i;
    
    if ( $target.hasClass( 'select-throw1') || $target.hasClass( 'select-throw2') || $target.hasClass( 'select-throw3')){
      
      // we are dealing with throw1 or throw2 select of any frame but the last
      if ( parseInt( $target.data("frameno")) < 9) { // 9 refers last frame i.e. 10th
      
        $target.prop( 'disabled', true);
      
        $val_s = $target.val();
        $val_i = parseInt( $val_s);
        
        $frameno_s = $target.data("frameno");
        $frameno_i = parseInt( $frameno_s);
        
        // we are dealing with throw1 select
        if ( $target.hasClass( 'select-throw1')){
          if ( $val_i == STRIKE ){
            $( ".select-throw1").parent().find("[ data-frameno='" + ( $frameno_i + 1).toString() + "']").prop( 'disabled', false).focus();
            $( '#cbx_pins_down_frame' + $frameno_s).val( "[10]");
          }
          else {
            var $sel = $( ".select-throw2").parent().find("[ data-frameno='" + $frameno_s + "']").prop( 'disabled', false);
            $sel.filterByNumeric( STRIKE - $val_i);
            $sel.focus();
          }
        }
        // endof we are dealing with throw1 select
        
        // we are dealing with throw2 select
        else if ( $target.hasClass( 'select-throw2')){
          $( ".select-throw1").parent().find("[ data-frameno='" + ( $frameno_i + 1).toString() + "']").prop( 'disabled', false).focus();
          $( '#cbx_pins_down_frame' + $frameno_s).val( "[" + $( ".select-throw1").parent().find("[ data-frameno='" + $frameno_s + "']").val() + ", " + $val_s + "]");
        // endof we are dealing with throw1 select
        }
      // endof we are dealing with throw1 or throw2 select of any frame but the last
      }
      
      // ... and now we deal with last frame
      if ( parseInt( $target.data("frameno")) == 9) { // 9 refers last frame i.e. 10th
      
        $target.prop( 'disabled', true);
      
        $val_s = $target.val();
        $val_i = parseInt( $val_s);
        
        $frameno_s = $target.data("frameno");
        $frameno_i = parseInt( $frameno_s);
        
        // we are dealing with throw1 select
        if ( $target.hasClass( 'select-throw1')){
        
          var $sel = $( ".select-throw2").parent().find("[ data-frameno='" + $frameno_s + "']").prop( 'disabled', false);
          
          if ( $val_i < STRIKE ){
            $sel.filterByNumeric( STRIKE - $val_i);
            $sel.focus();
          }
        }
        // endof we are dealing with throw1 select
        
        // we are dealing with throw2 select
        if ( $target.hasClass( 'select-throw2')){
        
          var $sel = $( ".select-throw1").parent().find("[ data-frameno='" + $frameno_s + "']");
          
          if ( parseInt( $sel.val()) == STRIKE ){
            $( ".select-throw3").parent().find("[ data-frameno='" + $frameno_s + "']").prop( 'disabled', false);
          }
          else {
            $( '#cbx_pins_down_frame' + $frameno_s).val( "[" + $( ".select-throw1").parent().find("[ data-frameno='" + $frameno_s + "']").val() + ", " + $val_s + "]");
            $( '#form_for_new_bowlgame :submit').removeClass( 'disabled');
            $( '#form_for_new_bowlgame :submit').prop( 'disabled', false);
          }
        }
        // endof we are dealing with throw2 select
        
        // we are dealing with throw3 select
        if ( $target.hasClass( 'select-throw3')){
          $( '#cbx_pins_down_frame' + $frameno_s).val( "[" + $( ".select-throw1").parent().find("[ data-frameno='" + $frameno_s + "']").val() + ", " + $( ".select-throw2").parent().find("[ data-frameno='" + $frameno_s + "']").val() + ", " + $val_s + "]");
          $( '#form_for_new_bowlgame :submit').removeClass( 'disabled');
          $( '#form_for_new_bowlgame :submit').prop( 'disabled', false);
        }
        // endof we are dealing with throw3 select
      // ... and now we deal with last frame      
      }
      
    }
  });

  // compute array of 10 subarrays for 10 frames, where a subarray contains the no. of pins downed respectively for the 1st and 2nd throw of a frame ( or
  // just the 1st throw if it is a strike.
  $('#form_for_new_bowlgame').on('submit', function(e){
    e.preventDefault();
    
    if ( true ){
      alert( 'Your bowling game has been submitted for evaluation of frame scores.\rTODO to revert with display of frame scores' );
      // this.submit(); // REMEMBER TO RESTORE
    }
  });
});
