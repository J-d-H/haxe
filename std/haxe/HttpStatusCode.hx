package haxe;

/**
	Http Status codes
	
	Status code comments: 
	Copyright (C) The Internet Society (1999). All Rights Reserved. 
**/
abstract HttpStatusCode (Int) from Int to Int {
	/**
		Indicates that no http status code was specified yet.
	**/
	@:extern public static inline var NotSet : HttpStatusCode = 0;
	
	//	Informational 1xx:
	
	/**
		100 Continue
		The client SHOULD continue with its request.
		
		This interim response is used to inform the client that the initial 
		part of the request has been received and has not yet been rejected by 
		the server. The client SHOULD continue by sending the remainder of the 
		request or, if the request has already been completed, ignore this 
		response. The server MUST send a final response after the request has 
		been completed.
	**/
	@:extern public static inline var Continue : HttpStatusCode = 100;
	/**
		101 Switching Protocols
		The server understands and is willing to comply with the client's request, via the Upgrade message header field, for a change in the application protocol being used on this connection. 
		
		The server will switch protocols to those defined by the response's 
		Upgrade header field immediately after the empty line which terminates 
		the 101 response.
	**/
	@:extern public static inline var SwitchingProtocols : HttpStatusCode = 101;
	
	
	//	Successful 2xx
	
	/**
		200 Ok
		The request has succeeded.
	**/
	@:extern public static inline var OK : HttpStatusCode = 200;
	/**
		201 Created
		The request has been fulfilled and resulted in a new resource being created. 
		
		The newly created resource can be referenced by the URI(s) returned in 
		the entity of the response, with the most specific URI for the resource 
		given by a Location header field. The response SHOULD include an entity 
		containing a list of resource characteristics and location(s) from 
		which the user or user agent can choose the one most appropriate. The 
		entity format is specified by the media type given in the Content-Type 
		header field. The origin server MUST create the resource before 
		returning the 201 status code. If the action cannot be carried out 
		immediately, the server SHOULD respond with 202 (Accepted) response 
		instead.
	**/
	@:extern public static inline var Created : HttpStatusCode = 201;
	/**
		202 Accepted
		The request has been accepted for processing, but the processing has not been completed. 
		
		The request might or might not eventually be acted upon, as it might be 
		disallowed when processing actually takes place. There is no facility 
		for re-sending a status code from an asynchronous operation such as 
		this.
		The 202 response is intentionally non-committal. Its purpose is to 
		allow a server to accept a request for some other process (perhaps a 
		batch-oriented process that is only run once per day) without 
		requiring that the user agent's connection to the server persist until 
		the process is completed. The entity returned with this response SHOULD 
		include an indication of the request's current status and either a 
		pointer to a status monitor or some estimate of when the user can 
		expect the request to be fulfilled.
	**/
	@:extern public static inline var Accepted : HttpStatusCode = 202;
	/**
		203 Non-Authoritative Information
		The returned metainformation in the entity-header is not the definitive set as available from the origin server, but is gathered from a local or a third-party copy.
		
		The set presented MAY be a subset or superset of the original version. 
		For example, including local annotation information about the resource 
		might result in a superset of the metainformation known by the origin 
		server. Use of this response code is not required and is only 
		appropriate when the response would otherwise be 200 (OK). 
	**/
	@:extern public static inline var NonAuthoritativeInformation : HttpStatusCode = 203;
	/**
		204 No Content
		The server has fulfilled the request but does not need to return an entity-body, and might want to return updated metainformation. 
		
		The response MAY include new or updated metainformation in the form of 
		entity-headers, which if present SHOULD be associated with the 
		requested variant. 
		
		If the client is a user agent, it SHOULD NOT change its document view 
		from that which caused the request to be sent. This response is 
		primarily intended to allow input for actions to take place without 
		causing a change to the user agent's active document view, although 
		any new or updated metainformation SHOULD be applied to the document 
		currently in the user agent's active view. 
		
		The 204 response MUST NOT include a message-body, and thus is always 
		terminated by the first empty line after the header fields. 
	**/
	@:extern public static inline var NoContent : HttpStatusCode = 204;
	/**
		205 Reset Content
		The server has fulfilled the request and the user agent SHOULD reset the document view which caused the request to be sent. 
		
		This response is primarily intended to allow input for actions to take 
		place via user input, followed by a clearing of the form in which the 
		input is given so that the user can easily initiate another input 
		action. The response MUST NOT include an entity.
	**/
	@:extern public static inline var ResetContent : HttpStatusCode = 205;
	/**
		206 Partial Content
		The server has fulfilled the partial GET request for the resource. 
		
		The request MUST have included a Range header field (section 14.35) 
		indicating the desired range, and MAY have included an If-Range header 
		field (section 14.27) to make the request conditional. 
		The response MUST include the following header fields: 
		-	Either a Content-Range header field (section 14.16) indicating the 
			range included with this response, or a multipart/byteranges 
			Content-Type including Content-Range fields for each part. If a 
			Content-Length header field is present in the response, its value 
			MUST match the actual number of OCTETs transmitted in the 
			message-body. 
		-	Date 
		-	ETag and/or Content-Location, if the header would have been sent 
			in a 200 response to the same request 
		-	Expires, Cache-Control, and/or Vary, if the field-value might
			differ from that sent in any previous response for the same
			variant
		If the 206 response is the result of an If-Range request that used a 
		strong cache validator (see section 13.3.3), the response SHOULD NOT 
		include other entity-headers. If the response is the result of an 
		If-Range request that used a weak validator, the response MUST NOT 
		include other entity-headers; this prevents inconsistencies between 
		cached entity-bodies and updated headers. Otherwise, the response MUST 
		include all of the entity-headers that would have been returned with a 
		200 (OK) response to the same request. 
	**/
	@:extern public static inline var PartialContent : HttpStatusCode = 206;
	
	
	//	Redirection 3xx
	
	/**
		300 Multiple Choices
		The requested resource corresponds to any one of a set of representations, each with its own specific location, and agent- driven negotiation information (section 12) is being provided so that the user (or user agent) can select a preferred representation and redirect its request to that location. 
		
		Unless it was a HEAD request, the response SHOULD include an entity 
		containing a list of resource characteristics and location(s) from 
		which the user or user agent can choose the one most appropriate. The 
		entity format is specified by the media type given in the Content-Type 
		header field. Depending upon the format and the capabilities of the 
		user agent, selection of the most appropriate choice MAY be performed 
		automatically. However, this specification does not define any standard 
		for such automatic selection. 
		
		If the server has a preferred choice of representation, it SHOULD 
		include the specific URI for that representation in the Location field; 
		user agents MAY use the Location field value for automatic redirection. 
		This response is cacheable unless indicated otherwise. 
	**/
	@:extern public static inline var MultipleChoices : HttpStatusCode = 300;
	/**
		301 Moved Permanently
		The requested resource has been assigned a new permanent URI and any future references to this resource SHOULD use one of the returned URIs. 
		
		Clients with link editing capabilities ought to automatically re-link 
		references to the Request-URI to one or more of the new references 
		returned by the server, where possible. This response is cacheable 
		unless indicated otherwise. 
		
		The new permanent URI SHOULD be given by the Location field in the 
		response. Unless the request method was HEAD, the entity of the 
		response SHOULD contain a short hypertext note with a hyperlink to the 
		new URI(s).
		
		If the 301 status code is received in response to a request other than 
		GET or HEAD, the user agent MUST NOT automatically redirect the request 
		unless it can be confirmed by the user, since this might change the 
		conditions under which the request was issued. 
	**/
	@:extern public static inline var MovedPermanently : HttpStatusCode = 301;
	/**
		302 Found
		The requested resource resides temporarily under a different URI. 
		
		Since the redirection might be altered on occasion, the client SHOULD 
		continue to use the Request-URI for future requests. This response is 
		only cacheable if indicated by a Cache-Control or Expires header field.
		
		The temporary URI SHOULD be given by the Location field in the response. 
		Unless the request method was HEAD, the entity of the response SHOULD 
		contain a short hypertext note with a hyperlink to the new URI(s).
		
		If the 302 status code is received in response to a request other than 
		GET or HEAD, the user agent MUST NOT automatically redirect the request 
		unless it can be confirmed by the user, since this might change the 
		conditions under which the request was issued. 
	**/
	@:extern public static inline var Found : HttpStatusCode = 302;
	/**
		303 See Other
		The response to the request can be found under a different URI and SHOULD be retrieved using a GET method on that resource. 
		
		This method exists primarily to allow the output of a POST-activated 
		script to redirect the user agent to a selected resource. The new URI 
		is not a substitute reference for the originally requested resource. 
		The 303 response MUST NOT be cached, but the response to the second 
		(redirected) request might be cacheable.
		
		The different URI SHOULD be given by the Location field in the 
		response. Unless the request method was HEAD, the entity of the 
		response SHOULD contain a short hypertext note with a hyperlink to the 
		new URI(s). 
	**/
	@:extern public static inline var SeeOther : HttpStatusCode = 303;
	/**
		304 Not Modified
		If the client has performed a conditional GET request and access is allowed, but the document has not been modified, the server SHOULD respond with this status code. 
		
		The 304 response MUST NOT contain a message-body, and thus is always 
		terminated by the first empty line after the header fields.
		
		The response MUST include the following header fields: 
			  - Date, unless its omission is required by section 14.18.1
		
		If a clockless origin server obeys these rules, and proxies and clients 
		add their own Date to any response received without one (as already 
		specified by [RFC 2068], section 14.19), caches will operate correctly. 
		- 	ETag and/or Content-Location, if the header would have been sent
			in a 200 response to the same request
		- 	Expires, Cache-Control, and/or Vary, if the field-value might
			differ from that sent in any previous response for the same
			variant
		
		If the conditional GET used a strong cache validator (see section 13.3.3), 
		the response SHOULD NOT include other entity-headers. Otherwise (i.e., 
		the conditional GET used a weak validator), the response MUST NOT 
		include other entity-headers; this prevents inconsistencies between 
		cached entity-bodies and updated headers.
		
		If a 304 response indicates an entity not currently cached, then the 
		cache MUST disregard the response and repeat the request without the 
		conditional. 
		
		If a cache uses a received 304 response to update a cache entry, the 
		cache MUST update the entry to reflect any new field values given in 
		the response. 
	**/
	@:extern public static inline var NotModified : HttpStatusCode = 304;
	/**
		305 Use Proxy
		The requested resource MUST be accessed through the proxy given by the Location field. 
		The Location field gives the URI of the proxy. The recipient is 
		expected to repeat this single request via the proxy. 305 responses 
		MUST only be generated by origin servers. 
	**/
	@:extern public static inline var UseProxy : HttpStatusCode = 305;
	/**
		306 (Unused)
		The 306 status code was used in a previous version of the specification, is no longer used, and the code is reserved. 
	**/
	@:extern public static inline var Unused : HttpStatusCode = 306;
	/**
		307 Temporary Redirect
		The requested resource resides temporarily under a different URI. 
		Since the redirection MAY be altered on occasion, the client SHOULD 
		continue to use the Request-URI for future requests. This response is 
		only cacheable if indicated by a Cache-Control or Expires header field. 
		
		The temporary URI SHOULD be given by the Location field in the 
		response. Unless the request method was HEAD, the entity of the 
		response SHOULD contain a short hypertext note with a hyperlink to the 
		new URI(s) , since many pre-HTTP/1.1 user agents do not understand the 
		307 status. Therefore, the note SHOULD contain the information 
		necessary for a user to repeat the original request on the new URI. 
		
		If the 307 status code is received in response to a request other than 
		GET or HEAD, the user agent MUST NOT automatically redirect the request 
		unless it can be confirmed by the user, since this might change the 
		conditions under which the request was issued. 
	**/
	@:extern public static inline var TemporaryRedirect : HttpStatusCode = 307;
	
	
	//	Client Error 4xx
	
	/**
		400 Bad Request
		The request could not be understood by the server due to malformed syntax. 
		The client SHOULD NOT repeat the request without modifications.
	**/
	@:extern public static inline var BadRequest : HttpStatusCode = 400;
	/**
		401 Unauthorized
		The request requires user authentication. 
		The response MUST include a WWW-Authenticate header field (section 14.47) 
		containing a challenge applicable to the requested resource. The client 
		MAY repeat the request with a suitable Authorization header 
		field (section 14.8). If the request already included Authorization 
		credentials, then the 401 response indicates that authorization has 
		been refused for those credentials. If the 401 response contains the 
		same challenge as the prior response, and the user agent has already 
		attempted authentication at least once, then the user SHOULD be 
		presented the entity that was given in the response, since that entity 
		might include relevant diagnostic information. HTTP access 
		authentication is explained in "HTTP Authentication: Basic and Digest 
		Access Authentication" [http://www.ietf.org/rfc/rfc2617.txt].
	**/
	@:extern public static inline var Unauthorized : HttpStatusCode = 401;
	/**
		402 Payment Required
		This code is reserved for future use.
	**/
	@:extern public static inline var PaymentRequired : HttpStatusCode = 402;
	/**
		403 Forbidden
		The server understood the request, but is refusing to fulfill it. 
		Authorization will not help and the request SHOULD NOT be repeated. If 
		the request method was not HEAD and the server wishes to make public 
		why the request has not been fulfilled, it SHOULD describe the reason 
		for the refusal in the entity. If the server does not wish to make this 
		information available to the client, the status code 404 (Not Found) 
		can be used instead. 
	**/
	@:extern public static inline var Forbidden : HttpStatusCode = 403;
	/**
		404 Not Found
		The server has not found anything matching the Request-URI.
		No indication is given of whether the condition is temporary or 
		permanent. The 410 (Gone) status code SHOULD be used if the server 
		knows, through some internally configurable mechanism, that an old 
		resource is permanently unavailable and has no forwarding address. This 
		status code is commonly used when the server does not wish to reveal 
		exactly why the request has been refused, or when no other response is 
		applicable.
	**/
	@:extern public static inline var NotFound : HttpStatusCode = 404;
	/**
		405 Method Not Allowed
		The method specified in the Request-Line is not allowed for the resource identified by the Request-URI. 
		The response MUST include an Allow header containing a list of valid 
		methods for the requested resource.
	**/
	@:extern public static inline var MethodNotAllowed : HttpStatusCode = 405;
	/**
		406 Not Acceptable
		The resource identified by the request is only capable of generating response entities which have content characteristics not acceptable according to the accept headers sent in the request.

		Unless it was a HEAD request, the response SHOULD include an entity 
		containing a list of available entity characteristics and location(s) 
		from which the user or user agent can choose the one most appropriate. 
		The entity format is specified by the media type given in the 
		Content-Type header field. Depending upon the format and the 
		capabilities of the user agent, selection of the most appropriate 
		choice MAY be performed automatically. However, this specification does 
		not define any standard for such automatic selection.
		
			Note: HTTP/1.1 servers are allowed to return responses which are
			not acceptable according to the accept headers sent in the
			request. In some cases, this may even be preferable to sending a
			406 response. User agents are encouraged to inspect the headers of
			an incoming response to determine if it is acceptable.
		
		If the response could be unacceptable, a user agent SHOULD temporarily 
		stop receipt of more data and query the user for a decision on further 
		actions.
	**/
	@:extern public static inline var NotAcceptable : HttpStatusCode = 406;
	/**
		407 Proxy Authentication Required
		This code is similar to 401 (Unauthorized), but indicates that the client must first authenticate itself with the proxy. 
		The proxy MUST return a Proxy-Authenticate header field (section 14.33) 
		containing a challenge applicable to the proxy for the requested 
		resource. The client MAY repeat the request with a suitable 
		Proxy-Authorization header field (section 14.34). HTTP access 
		authentication is explained in "HTTP Authentication: Basic and Digest 
		Access Authentication" [http://www.ietf.org/rfc/rfc2617.txt].
	**/
	@:extern public static inline var ProxyAuthenticationRequired : HttpStatusCode = 407;
	/**
		408 Request Timeout
		The client did not produce a request within the time that the server was prepared to wait. 
		The client MAY repeat the request without modifications at any later time.
	**/
	@:extern public static inline var RequestTimeout : HttpStatusCode = 408;
	/**
		409 Conflict
		The request could not be completed due to a conflict with the current state of the resource. 
		This code is only allowed in situations where it is expected that the 
		user might be able to resolve the conflict and resubmit the request. 
		The response body SHOULD include enough information for the user to 
		recognize the source of the conflict. Ideally, the response entity 
		would include enough information for the user or user agent to fix the 
		problem; however, that might not be possible and is not required.
		
		Conflicts are most likely to occur in response to a PUT request. For 
		example, if versioning were being used and the entity being PUT 
		included changes to a resource which conflict with those made by an 
		earlier (third-party) request, the server might use the 409 response to 
		indicate that it can't complete the request. In this case, the response 
		entity would likely contain a list of the differences between the two 
		versions in a format defined by the response Content-Type.
	**/
	@:extern public static inline var Conflict : HttpStatusCode = 409;
	/**
		410 Gone
		The requested resource is no longer available at the server and no forwarding address is known.
		This condition is expected to be considered permanent. Clients with 
		link editing capabilities SHOULD delete references to the Request-URI 
		after user approval. If the server does not know, or has no facility to 
		determine, whether or not the condition is permanent, the status code 
		404 (Not Found) SHOULD be used instead. This response is cacheable 
		unless indicated otherwise.
		
		The 410 response is primarily intended to assist the task of web 
		maintenance by notifying the recipient that the resource is 
		intentionally unavailable and that the server owners desire that remote 
		links to that resource be removed. Such an event is common for 
		limited-time, promotional services and for resources belonging to 
		individuals no longer working at the server's site. It is not necessary 
		to mark all permanently unavailable resources as "gone" or to keep the 
		mark for any length of time -- that is left to the discretion of the 
		server owner. 
	**/
	@:extern public static inline var Gone : HttpStatusCode = 410;
	/**
		411 Length Required
		The server refuses to accept the request without a defined Content-Length. 
		The client MAY repeat the request if it adds a valid Content-Length 
		header field containing the length of the message-body in the request 
		message.
	**/
	@:extern public static inline var LengthRequired : HttpStatusCode = 411;
	/**
		412 Precondition Failed
		The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server. 
		This response code allows the client to place preconditions on the 
		current resource metainformation (header field data) and thus prevent 
		the requested method from being applied to a resource other than the 
		one intended.
	**/
	@:extern public static inline var PreconditionFailed : HttpStatusCode = 412;
	/**
		413 Request Entity Too Large
		The server is refusing to process a request because the request entity is larger than the server is willing or able to process. 
		The server MAY close the connection to prevent the client from 
		continuing the request.
		If the condition is temporary, the server SHOULD include a Retry-After 
		header field to indicate that it is temporary and after what time the 
		client MAY try again.
	**/
	@:extern public static inline var RequestEntityTooLarge : HttpStatusCode = 413;
	/**
		Status 414: Request-URI Too Long
		The server is refusing to service the request because the Request-URI is longer than the server is willing to interpret. 
		This rare condition is only likely to occur when a client has 
		improperly converted a POST request to a GET request with long query 
		information, when the client has descended into a URI "black hole" of 
		redirection (e.g., a redirected URI prefix that points to a suffix of 
		itself), or when the server is under attack by a client attempting to 
		exploit security holes present in some servers using fixed-length 
		buffers for reading or manipulating the Request-URI.
	**/
	@:extern public static inline var RequestUriTooLong : HttpStatusCode = 414;
	/**
		415 Unsupported Media Type
		The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method.
	**/
	@:extern public static inline var UnsupportedMediaType : HttpStatusCode = 415;
	/**
		416 Requested Range Not Satisfiable
		A server SHOULD return a response with this status code if a request included a Range request-header field (section 14.35), and none of the range-specifier values in this field overlap the current extent of the selected resource, and the request did not include an If-Range request-header field. 
		(For byte-ranges, this means that the first- byte-pos of all of the 
		byte-range-spec values were greater than the current length of the 
		selected resource.)
		
		When this status code is returned for a byte-range request, the 
		response SHOULD include a Content-Range entity-header field specifying 
		the current length of the selected resource (see section 14.16). This 
		response MUST NOT use the multipart/byteranges content- type.
	**/
	@:extern public static inline var RequestedRangeNotSatisfiable : HttpStatusCode = 416;
	/**
		417 Expectation Failed
		The expectation given in an Expect request-header field (see section 14.20) could not be met by this server, or, if the server is a proxy, the server has unambiguous evidence that the request could not be met by the next-hop server.
	**/
	@:extern public static inline var ExpectationFailed : HttpStatusCode = 417;
	
	
	/*
		Server Error 5xx
		
		Response status codes beginning with the digit "5" indicate cases in 
		which the server is aware that it has erred or is incapable of 
		performing the request. Except when responding to a HEAD request, the 
		server SHOULD include an entity containing an explanation of the error 
		situation, and whether it is a temporary or permanent condition. User 
		agents SHOULD display any included entity to the user. These response 
		codes are applicable to any request method.
	*/
	
	/**
		500 Internal Server Error
		The server encountered an unexpected condition which prevented it from fulfilling the request. 
	**/
	@:extern public static inline var InternalServerError : HttpStatusCode = 500;
	/**
		501 Not Implemented
		The server does not support the functionality required to fulfill the request. 
		This is the appropriate response when the server does not recognize the 
		request method and is not capable of supporting it for any resource.
	**/
	@:extern public static inline var NotImplemented : HttpStatusCode = 501;
	/**
		502 Bad Gateway
		The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.
	**/
	@:extern public static inline var BadGateway : HttpStatusCode = 502;
	/**
		503 Service Unavailable
		The server is currently unable to handle the request due to a temporary overloading or maintenance of the server. 
		The implication is that this is a temporary condition which will be 
		alleviated after some delay. If known, the length of the delay MAY be 
		indicated in a Retry-After header. If no Retry-After is given, the 
		client SHOULD handle the response as it would for a 500 response.
		
			Note: The existence of the 503 status code does not imply that a
			server must use it when becoming overloaded. Some servers may wish
			to simply refuse the connection
	**/
	@:extern public static inline var ServiceUnavailable : HttpStatusCode = 503;
	/**
		504 Gateway Timeout
		The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server specified by the URI (e.g. HTTP, FTP, LDAP) or some other auxiliary server (e.g. DNS) it needed to access in attempting to complete the request.
		
			Note: Note to implementors: some deployed proxies are known to
			return 400 or 500 when DNS lookups time out.
	**/
	@:extern public static inline var GatewayTimeout : HttpStatusCode = 504;
	/**
		Status 505: HTTP Version Not Supported
		The server does not support, or refuses to support, the HTTP protocol version that was used in the request message. 
		The server is indicating that it is unable or unwilling to complete the 
		request using the same major version as the client, as described in 
		section 3.1, other than with this error message. The response SHOULD 
		contain an entity describing why that version is not supported and 
		what other protocols are supported by that server.
		
		[http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.1]
	**/
	@:extern public static inline var HttpVersionNotSupported : HttpStatusCode = 505;
	
	
	
	// abstract implementation:
	
	public inline function new( code : Int ) {
		this = code;
	}
	
	@:to public function toString() : String {
		return switch( this ) {
			case HttpStatusCode.Continue:						"100 Continue";
			case HttpStatusCode.SwitchingProtocols:				"101 Switching Protocols";
			case HttpStatusCode.OK:								"200 Ok";
			case HttpStatusCode.Created:						"201 Created";
			case HttpStatusCode.Accepted:						"202 Accepted";
			case HttpStatusCode.NonAuthoritativeInformation:	"203 Non-Authoritative Information";
			case HttpStatusCode.NoContent:						"204 No Content";
			case HttpStatusCode.ResetContent:					"205 Reset Content";
			case HttpStatusCode.PartialContent:					"206 PartialContent";
			case HttpStatusCode.MultipleChoices:				"300 Multiple Choices";
			case HttpStatusCode.MovedPermanently:				"301 Moved Permanently";
			case HttpStatusCode.Found:							"302 Moved";
			case HttpStatusCode.SeeOther:						"303 Found";
			case HttpStatusCode.NotModified:					"304 NotModified";
			case HttpStatusCode.UseProxy:						"305 UseProxy";
			case HttpStatusCode.Unused:							"306 Unused";
			case HttpStatusCode.TemporaryRedirect:				"307 Temporary Redirect";
			case HttpStatusCode.BadRequest:						"400 Bad Request";
			case HttpStatusCode.Unauthorized:					"401 Unauthorized";
			case HttpStatusCode.PaymentRequired:				"402 Payment Required";
			case HttpStatusCode.Forbidden:						"403 Forbidden";
			case HttpStatusCode.NotFound:						"404 Not Found";
			case HttpStatusCode.MethodNotAllowed:				"405 Method Not Allowed";
			case HttpStatusCode.NotAcceptable:					"406 Not Acceptable";
			case HttpStatusCode.ProxyAuthenticationRequired:	"407 Proxy Authentication Required";
			case HttpStatusCode.RequestTimeout:					"408 Request Timeout";
			case HttpStatusCode.Conflict:						"409 Conflict";
			case HttpStatusCode.Gone:							"410 Gone";
			case HttpStatusCode.LengthRequired:					"411 Length Required";
			case HttpStatusCode.PreconditionFailed:				"412 Precondition Failed";
			case HttpStatusCode.RequestEntityTooLarge:			"413 Request Entity Too Large";
			case HttpStatusCode.RequestUriTooLong:				"414 Request-URI Too Long";
			case HttpStatusCode.UnsupportedMediaType:			"415 Unsupported Media Type";
			case HttpStatusCode.RequestedRangeNotSatisfiable:	"416 Requested Range Not Satisfiable";
			case HttpStatusCode.ExpectationFailed:				"417 Expectation Failed";
			case HttpStatusCode.InternalServerError:			"500 Internal Server Error";
			case HttpStatusCode.NotImplemented:					"501 Not Implemented";
			case HttpStatusCode.BadGateway:						"502 Bad Gateway";
			case HttpStatusCode.ServiceUnavailable:				"503 Service Unavailable";
			case HttpStatusCode.GatewayTimeout:					"504 Gateway Timeout";
			case HttpStatusCode.HttpVersionNotSupported:		"505 HTTP Version Not Supported";
			default:											this + " Unknown";
		}
	}
	
	@:to public inline function toDynamic() : Dynamic {
		return toString();
	}
	
	#if cs
	@:from @:noCompletion public static function fromCSHttpStatusCode ( code : CSHttpStatusCode ) : HttpStatusCode {
		return new HttpStatusCode( cast(code, Int) );
	}
	#end
}


#if cs
@:native("System.Net.HttpStatusCode") 
extern enum CSHttpStatusCode {
	Continue; // Equivalent to HTTP status 100. Continue indicates that the client can continue with its request. 
	SwitchingProtocols; // Equivalent to HTTP status 101. SwitchingProtocols indicates that the protocol version or protocol is being changed. 
	OK; // Equivalent to HTTP status 200. OK indicates that the request succeeded and that the requested information is in the response. This is the most common status code to receive. 
	Created; // Equivalent to HTTP status 201. Created indicates that the request resulted in a new resource created before the response was sent. 
	Accepted; // Equivalent to HTTP status 202. Accepted indicates that the request has been accepted for further processing. 
	NonAuthoritativeInformation; // Equivalent to HTTP status 203. NonAuthoritativeInformation indicates that the returned metainformation is from a cached copy instead of the origin server and therefore may be incorrect. 
	NoContent; // Equivalent to HTTP status 204. NoContent indicates that the request has been successfully processed and that the response is intentionally blank. 
	ResetContent; // Equivalent to HTTP status 205. ResetContent indicates that the client should reset (not reload) the current resource. 
	PartialContent; // Equivalent to HTTP status 206. PartialContent indicates that the response is a partial response as requested by a GET request that includes a byte range. 
	MultipleChoices; // Equivalent to HTTP status 300. MultipleChoices indicates that the requested information has multiple representations. The default action is to treat this status as a redirect and follow the contents of the Location header associated with this response. If the HttpWebRequest.AllowAutoRedirect property is false, MultipleChoices will cause an exception to be thrown. MultipleChoices is a synonym for Ambiguous.
	Ambiguous; // Equivalent to HTTP status 300. Ambiguous indicates that the requested information has multiple representations. The default action is to treat this status as a redirect and follow the contents of the Location header associated with this response. If the HttpWebRequest.AllowAutoRedirect property is false, Ambiguous will cause an exception to be thrown. Ambiguous is a synonym for MultipleChoices.
	MovedPermanently; // Equivalent to HTTP status 301. MovedPermanently indicates that the requested information has been moved to the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. MovedPermanently is a synonym for Moved.
	Moved; // Equivalent to HTTP status 301. Moved indicates that the requested information has been moved to the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. When the original request method was POST, the redirected request will use the GET method. Moved is a synonym for MovedPermanently.
	Found; // Equivalent to HTTP status 302. Found indicates that the requested information is located at the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. When the original request method was POST, the redirected request will use the GET method. If the HttpWebRequest.AllowAutoRedirect property is false, Found will cause an exception to be thrown. Found is a synonym for Redirect.
	Redirect; // Equivalent to HTTP status 302. Redirect indicates that the requested information is located at the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. When the original request method was POST, the redirected request will use the GET method. If the HttpWebRequest.AllowAutoRedirect property is false, Redirect will cause an exception to be thrown. Redirect is a synonym for Found.
	SeeOther; // Equivalent to HTTP status 303. SeeOther automatically redirects the client to the URI specified in the Location header as the result of a POST. The request to the resource specified by the Location header will be made with a GET. If the HttpWebRequest.AllowAutoRedirect property is false, SeeOther will cause an exception to be thrown. SeeOther is a synonym for RedirectMethod.
	RedirectMethod; // Equivalent to HTTP status 303. RedirectMethod automatically redirects the client to the URI specified in the Location header as the result of a POST. The request to the resource specified by the Location header will be made with a GET. If the HttpWebRequest.AllowAutoRedirect property is false, RedirectMethod will cause an exception to be thrown. RedirectMethod is a synonym for SeeOther.
	NotModified; // Equivalent to HTTP status 304. NotModified indicates that the client's cached copy is up to date. The contents of the resource are not transferred. 
	UseProxy; // Equivalent to HTTP status 305. UseProxy indicates that the request should use the proxy server at the URI specified in the Location header. 
	Unused; // Equivalent to HTTP status 306. Unused is a proposed extension to the HTTP/1.1 specification that is not fully specified. 
	TemporaryRedirect; // Equivalent to HTTP status 307. TemporaryRedirect indicates that the request information is located at the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. When the original request method was POST, the redirected request will also use the POST method. If the HttpWebRequest.AllowAutoRedirect property is false, TemporaryRedirect will cause an exception to be thrown. TemporaryRedirect is a synonym for RedirectKeepVerb. 
	RedirectKeepVerb; // Equivalent to HTTP status 307. RedirectKeepVerb indicates that the request information is located at the URI specified in the Location header. The default action when this status is received is to follow the Location header associated with the response. When the original request method was POST, the redirected request will also use the POST method. If the HttpWebRequest.AllowAutoRedirect property is false, RedirectKeepVerb will cause an exception to be thrown. RedirectKeepVerb is a synonym for TemporaryRedirect.
	BadRequest; // Equivalent to HTTP status 400. BadRequest indicates that the request could not be understood by the server. BadRequest is sent when no other error is applicable, or if the exact error is unknown or does not have its own error code. 
	Unauthorized; // Equivalent to HTTP status 401. Unauthorized indicates that the requested resource requires authentication. The WWW-Authenticate header contains the details of how to perform the authentication. 
	PaymentRequired; // Equivalent to HTTP status 402. PaymentRequired is reserved for future use. 
	Forbidden; // Equivalent to HTTP status 403. Forbidden indicates that the server refuses to fulfill the request. 
	NotFound; // Equivalent to HTTP status 404. NotFound indicates that the requested resource does not exist on the server. 
	MethodNotAllowed; // Equivalent to HTTP status 405. MethodNotAllowed indicates that the request method (POST or GET) is not allowed on the requested resource. 
	NotAcceptable; // Equivalent to HTTP status 406. NotAcceptable indicates that the client has indicated with Accept headers that it will not accept any of the available representations of the resource. 
	ProxyAuthenticationRequired; // Equivalent to HTTP status 407. ProxyAuthenticationRequired indicates that the requested proxy requires authentication. The Proxy-authenticate header contains the details of how to perform the authentication. 
	RequestTimeout; // Equivalent to HTTP status 408. RequestTimeout indicates that the client did not send a request within the time the server was expecting the request. 
	Conflict; // Equivalent to HTTP status 409. Conflict indicates that the request could not be carried out because of a conflict on the server. 
	Gone; // Equivalent to HTTP status 410. Gone indicates that the requested resource is no longer available. 
	LengthRequired; // Equivalent to HTTP status 411. LengthRequired indicates that the required Content-length header is missing. 
	PreconditionFailed; // Equivalent to HTTP status 412. PreconditionFailed indicates that a condition set for this request failed, and the request cannot be carried out. Conditions are set with conditional request headers like If-Match, If-None-Match, or If-Unmodified-Since. 
	RequestEntityTooLarge; // Equivalent to HTTP status 413. RequestEntityTooLarge indicates that the request is too large for the server to process. 
	RequestUriTooLong; // Equivalent to HTTP status 414. RequestUriTooLong indicates that the URI is too long. 
	UnsupportedMediaType; // Equivalent to HTTP status 415. UnsupportedMediaType indicates that the request is an unsupported type. 
	RequestedRangeNotSatisfiable; // Equivalent to HTTP status 416. RequestedRangeNotSatisfiable indicates that the range of data requested from the resource cannot be returned, either because the beginning of the range is before the beginning of the resource, or the end of the range is after the end of the resource. 
	ExpectationFailed; // Equivalent to HTTP status 417. ExpectationFailed indicates that an expectation given in an Expect header could not be met by the server. 
	InternalServerError; // Equivalent to HTTP status 500. InternalServerError indicates that a generic error has occurred on the server. 
	NotImplemented; // Equivalent to HTTP status 501. NotImplemented indicates that the server does not support the requested function. 
	BadGateway; // Equivalent to HTTP status 502. BadGateway indicates that an intermediate proxy server received a bad response from another proxy or the origin server. 
	ServiceUnavailable; // Equivalent to HTTP status 503. ServiceUnavailable indicates that the server is temporarily unavailable, usually due to high load or maintenance. 
	GatewayTimeout; // Equivalent to HTTP status 504. GatewayTimeout indicates that an intermediate proxy server timed out while waiting for a response from another proxy or the origin server. 
	HttpVersionNotSupported; // Equivalent to HTTP status 505. HttpVersionNotSupported indicates that the requested HTTP version is not supported by the server. 
}
#end