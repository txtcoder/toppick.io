get_hot = function() {
    $.ajax({
        type: 'GET',
        url: '/?sort=hot&partial=hot',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
        }
    });
};
get_views = function() {
    $.ajax({
        type: 'GET',
        url: '/?sort=views&partial=views',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
        }
    });
};
get_editor = function() {
    $.ajax({
        type: 'GET',
        url: '/?sort=editor&partial=editor',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
        }
    });
};
get_new = function() {
    $.ajax({
        type: 'GET',
        url: '/?sort=new&partial=new',
        async: true,
        success: function(result) {
            $("#catalogue").replaceWith(result);
        }
    });
};

