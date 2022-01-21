http_requests = {}; // Struct of requests

/**
 * Make an API call and returns the related promise.
 */
function scr_make_api_call(url) {
	// Pass local variables to the function scope below
	var closure = { url: url };
	
	return new Promise(method(closure, function(promise) {
		var requestId = http_get(url);
	
		// Store the promise for fullfilling (in the Async HTTP event)
		variable_struct_set(global.http_requests, requestId, promise);
	}))
}