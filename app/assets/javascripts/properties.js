
$(document).ready(function(){
//    register event handler for sorting
$('#sorter select').change(sort_results); 
setCurrentSortOrder();
//set click handlers for note creation and editing
$('#edit-note').click(function(){
    $('#note-editor').show();
    $('#note-viewer').hide();
    $('#note-editor textarea').val($('#note-viewer .viewer').text());
});
$('#note-editor button').click(save_note);

});

function save_note(){
    var note = $('#note-editor textarea').val();
    var property_id = $('#property-info').attr('data-property-id');
    $.post('/properties/'+property_id+'/notes',{'note': note},function(response){
       if(response.saved){
      $('#note-viewer').show();
      $('#note-viewer .viewer').text(note);
      $('#note-editor').hide();
       }
    });
}


function sort_results(){
window.location = updateQueryStringParameter(document.URL,'orderby',$('#sorter select').val());
}
        
/**
 * Adds or replaces a string in url
 */
function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
  var separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}

function setCurrentSortOrder(){
    var sorter = $('#sorter select');
    var sort_val = parseInt(sorter.attr('data-currentsort'));
    sorter.find('option').each(function(key,elem){        
        if(sort_val == parseInt($(elem).val())){
            $(elem).attr('selected',true);
        }        
    });
}