 /**
  * Ratings widget
  * @param {type} post_url
  * @returns {Ratings}
  */
 function Ratings(server,widget){
     this.server = server;     
         this.set_divs(widget); //define inner divs for each rating widget
         this.get_rating(widget);
    $(widget).find('.ratings_stars').hover($.proxy(this.mouseover,this),$.proxy(this.mouseout,this)).click($.proxy(this.set_rating,this));
    $(widget).find('.ratings_delete').click($.proxy(this.set_rating,this));
     
 }

/**
 * Records ratings
 * @param {type} star
 * @returns {undefined}
 */
    Ratings.prototype.set_rating = function(event){
        var star = event.currentTarget;
            var widget = $(star).parent();
            
            var clicked_data = {
                rating : $(star).attr('data-rating')
            };
            $.post(
                this.server,
                clicked_data,
                $.proxy(function(response) {
                    widget.data('rating', response );
                    this.set_votes(widget);
                },this),
                'json'
            );
    };

/**
 * Defines mouseover behaviour for ratings
 * @returns {undefined}
 */
    Ratings.prototype.mouseover = function(event){
        var star = event.currentTarget;
                $(star).prevAll().andSelf().addClass('ratings_over');
                $(star).nextAll().removeClass('ratings_vote');        
    };
    
    /**
     * Defines mouseout behaviour for ratings
     * @returns {undefined}
     */
    Ratings.prototype.mouseout = function(event){
        var star = event.currentTarget;
                $(star).prevAll().andSelf().removeClass('ratings_over');
                // can't use 'this' because it wont contain the updated data
                this.set_votes($(star).parent());        
    };

/**
 * define the divs where our ratings stars would be saved in per specified widget
 * @returns {undefined}
 */
    Ratings.prototype.set_divs = function(widget){
        var star_count = 5;
        $(widget).addClass('ratings-widget');
        for(var i=1;i<=star_count;i++){
            $(widget).append('<div class="star_'+i+' ratings_stars clickable" data-rating="'+i+'"></div>');
        }
//        attach delete button
        $(widget).append('<div class="ratings_delete clickable" data-rating="0"></div>');        
        
    };

/**
 * Gets rating from the server as specified by widget
 * @returns {undefined}
 */
    Ratings.prototype.get_rating = function(widget){
            $.get(
                this.server,{},
                $.proxy(function(response) {                    
                    $(widget).data( 'rating', response );                  
                    this.set_votes(widget);
                },this),
                'json'
            );        
    };

    Ratings.prototype.set_votes = function (widget) {
        var rating = parseInt($(widget).data('rating').rating);
        $(widget).find('.ratings_vote').removeClass('ratings_vote');
        for(var i=1;i<=rating;i++){
           $(widget).find('.star_'+i).addClass('ratings_vote');
        }
        //show delete buttin if rating is greater than one
        if(rating >= 1) $(widget).find('.ratings_delete').show();
            else $(widget).find('.ratings_delete').hide();
    };