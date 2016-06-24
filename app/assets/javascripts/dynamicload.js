clear_active = function () {
    $(".view_all").removeClass("active");
    $(".top_viewed").removeClass("active");
    $(".editor_pick").removeClass("active");
    $(".new_old").removeClass("active");
};

get_hot = function() {
    clear_active();
    $(".view_all").addClass("active");
    $.ajax({
        type: 'GET',
        url: '/?sort=hot&partial=hot',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
            new WOW().init();
        }
    });
};
get_views = function() {
    clear_active();
    $(".top_viewed").addClass("active");
    $.ajax({
        type: 'GET',
        url: '/?sort=views&partial=views',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
            new WOW().init();
        }
    });
};
get_editor = function() {
    clear_active();
    $(".editor_pick").addClass("active");
    $.ajax({
        type: 'GET',
        url: '/?sort=editor&partial=editor',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
            new WOW().init();
        }
    });
};
get_new = function() {
    clear_active();
    $(".new_old").addClass("active");
    $.ajax({
        type: 'GET',
        url: '/?sort=new&partial=new',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
            new WOW().init();
        }
    });
};

