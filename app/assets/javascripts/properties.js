
$(document).ready(function(){
//    register event handler for sorting
$('#sorter select').change(sort_results); 
$('.mark-property').click(mark_property);
setCurrentSortOrder();
});

function mark_property(elem){
    var marker = $(elem.currentTarget)
    var property_id = marker.parent().parent().attr('data-property-id');
    $.get('/properties/bookmark',{'property':property_id},function(response){
        if(response.marked)
            marker.removeClass('btn-info').addClass('btn-danger').text('Unmark');
        else
            marker.removeClass('btn-danger').addClass('btn-info').text('Mark');
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