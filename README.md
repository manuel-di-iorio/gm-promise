# Promise implementation for Game Maker Studio 2

Adds the support for a similar Promise implementation on GMS 2 through the usage of struct constructors and callbacks arrays.

Example:

```gml
// Execute the first HTTP call
scr_make_api_call("https://jsonplaceholder.typicode.com/todos/1")

 // With the .next() function, this second HTTP request will be automatically executed after the response of the previous one
.next(function(todo_resp) {
	show_debug_message(todo_resp); // { "userId": 1, "id": 1,	"title": "delectus aut autem", "completed": false }

	// As you can see, promises can be returned to create a chain of requests:
	return scr_make_api_call("https://jsonplaceholder.typicode.com/todos/2");
})

.next(show_debug_message) // { "userId": 1, "id": 2,	"title": "quis ut nam facilis et officia qui", "completed": false }

// Catch errors (executed when calling the promise.reject() method)
.error(show_debug_message);
```

## APIs

promise.next()

promise.error()

promise.resolve()

promise.reject()

## LICENSE

MIT
