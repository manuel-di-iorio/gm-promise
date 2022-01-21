/**
 * Create a Promise-like struct with next/error functions.
 * Callbacks execution (success/error) have to be externally handled, pratically calling promise.resolve() and promise.reject()
 *
 * Similar reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
 *
 * @author Emmanuel Di Iorio (aka "Xeryan")
 * @version 1.0.0
 * @license MIT
 *
 * @param {Function} executor The function that will be executed after the promise initialization
 * @param {Any} [context] Any data that may be stored inside the struct for later usage (optional)
 * 
 * @return {Struct<Promise>}
 */
function Promise(executor, context = undefined) constructor {
	self.context = context;
	__success_callbacks = [];
	__error_callbacks = [];
	
	/**
	 * This is the main internal method, used to recursively call the first callback in the list.
	 */
	__exec = function(array, resp) {
		// When a callback returns a Struct<Promise>, add an interceptor in the original promise in order to inject the response into this parent promise
		if (is_struct(resp) && instanceof(resp) == "Promise") {			
			resp.next(resolve);
			resp.error(reject);
			return;
		}
			
		// Execute the first callback in the list
		if (!array_length(array)) return;
		var callback = array[0];
		array_delete(array, 0, 1);
		callback(resp);
	};
	
	/**
	 * Fullfill the promise with a success response. Will recursively call the next callback in the chain
	 */
	resolve = function(resp) {
		__exec(__success_callbacks, resp);
	};
	
	/**
	 * Reject the promise with an error
	 * @note: By rejecting the promise, all other success callbacks in the chain will be dropped
	 */	
	reject = function(err) {
		__success_callbacks = [];
		__exec(__error_callbacks, err);
	};
	
	/**
	 * Add a success callback to the list
	 */
	next = function(func) {
		var closure = {
			func: func,
			__exec: __exec,
			__success_callbacks: __success_callbacks,
			__error_callbacks: __error_callbacks
		};
		
		array_push(__success_callbacks, method(closure, function(resp) {
			__exec(__success_callbacks, func(resp));
		}));
		
		return self;
	};
	
	/**
	 * Add an error callback to the list
	 */
	error = function(func) {
		var closure = {
			func: func,
			__exec: __exec,
			__success_callbacks: __success_callbacks,
			__error_callbacks: __error_callbacks
		};
		
		array_push(__error_callbacks, method(closure, function(err) {
			__exec(__error_callbacks, func(err));
		}));
		
		return self;
	};
	
	// Simplified callback pattern
	// Example: function(err, resp) {}
	addCallback = function(callback) {
		var closure = { callback: callback };
		self.next(method(closure, function(resp) { callback(undefined, resp); }));
		self.error(method(closure, function(err) { callback(err); }));
	}
	
	// Execute the promise function
	executor(self);
}