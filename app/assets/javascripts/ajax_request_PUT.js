function _ajax_request(url, data, callback, type, method) {
    return jQuery.ajax({
        type: 'PUT',
        url: "slot_days/show",
        data: data,
        success: function(result)
        {
        	callback();
        }
    });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
}});  



