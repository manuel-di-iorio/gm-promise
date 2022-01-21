var req_id = async_load[? "id"];
if (!variable_struct_exists(global.http_requests, req_id)) exit;
var promise = global.http_requests[$ req_id];

try {
	var result = async_load[? "result"];
	promise.resolve(json_parse(result));
} catch (err) {
	promise.reject(err);
}