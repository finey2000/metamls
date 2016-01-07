
$(document).ready(function(){
//    register event handler for sorting
$('#sorter select').change(sort_results); 
setCurrentSortOrder();
//set click handlers for note creation and editing
$('.property.note .view-block .action').click(function(){
    $('.property.note .edit-block').show();
    $('.property.note .view-block').hide();
    $('.property.note textarea').val($('.property.note .viewer').text());
});
$('.property.note .edit-block button').click(save_note);

});

function save_note(){
    var note = $('.property.note textarea').val();
    var property_id = $('#property-info').attr('data-property-id');
    $.post('/properties/'+property_id+'/notes',{'note': note},function(response){
       if(response.saved){
      $('.property.note .view-block').show();
      $('.property.note .viewer').text(note);
      $('.property.note .view-block .action').text('Edit');      
      $('.property.note .edit-block').hide();
      ratingsWidget.get_rating();
       }
    });
}

function delete_note(){
          $('.property.note .viewer').text('');
          $('.property.note .view-block .action').text('Create');              
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