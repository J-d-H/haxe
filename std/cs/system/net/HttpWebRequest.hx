package cs.system.net;

import cs.NativeArray;
import cs.system.collections.ICollection;
import cs.system.collections.IEnumerator;
import cs.system.DateTime;
import cs.system.IAsyncResult;
import cs.system.io.Stream;
import haxe.io.BytesData;

@:native("System.Net.WebRequest") 
extern class WebRequest {
	public var ContentLength (default, default) : Int;
	public var ContentType (default, default) : String;
	public var Headers (default, default) : WebHeaderCollection;
	public var Method (default, default) : String;
	public var RequestUri (default, never) : String;
	public var PreAuthenticate (default, default) : Bool;
	//public var Proxy (default, default) : IWebProxy;
	public var Timeout (default, default) : Int;
	
	public function Abort() : Void;
	public function BeginGetRequestStream( callback : AsyncCallback, state : Dynamic ) : IAsyncResult;
	public function BeginGetResponse( callback : AsyncCallback, state : Dynamic ) : IAsyncResult;
	public function EndGetRequestStream( asyncResult : IAsyncResult ) : Stream;
	public function EndGetResponse( asyncResult : IAsyncResult ) : WebResponse;
	
	/**
	 * Initializes a new WebRequest instance for the specified URI scheme.
	 * The .NET Framework includes support for the http://, https://, and file:// URI schemes
	 */
	public static function Create( requestUriString : String ) : WebRequest;
	
	/**
	 * Returns a Stream for writing data to the Internet resource.
	 */
	public function GetRequestStream() : Stream;
	
	public function GetResponse() : WebResponse;
}


@:native("System.Net.Security.AuthenticationLevel") enum AuthenticationLevel {
	None;
	MutualAuthRequested;
	MutualAuthRequired;
}

@:native("System.Net.DecompressionMethods") enum DecompressionMethods {
	None;
	GZip;
	Deflate;
}

@:native("System.Net.WebRequestMethods.Http") 
extern class HttpWebRequestMethods {
	static public var Connect(default, never) : String;
	static public var Get(default, never) : String;
	static public var Post(default, never) : String;
	static public var Put(default, never) : String;
}

@:native("System.Net.HttpWebRequest") 
extern class HttpWebRequest extends WebRequest {
	/**
	 * Gets or sets the Accept HTTP header.
	 */
	public var Accept (default, default) : String;
	/**
	 * Gets the Uniform Resource Identifier (URI) of the Internet resource that actually responds to the request.
	 */
	public var Address (default, never) : String;
	/**
	 * Gets or sets the Expect HTTP header.
	 */
	public var AllowAutoRedirect (default, default) : Bool;
	public var AllowWriteStreamBuffering (default, default) : Bool;
	public var AuthenticationLevel (default, default) : AuthenticationLevel;
	public var AutomaticDecompression (default, default) : DecompressionMethods;
	public var Connection (default, default) : String;
	public var Expect (default, default) : String;
	public var HaveResponse (default, never) : Bool;
	/**
	 * Gets or sets the If-Modified-Since HTTP header.
	 */
	public var IfModifiedSince (default, default) : DateTime;
	public var KeepAlive (default, default) : Bool;
	public var Pipelined (default, default) : Bool;
	public var ReadWriteTimeout (default, default) : Int;
	/**
	 * Gets or sets the Referer HTTP header.
	 */
	public var Referer (default, default) : String;
	public var SendChunked (default, default) : Bool;
	public var TransferEncoding (default, default) : String;
	public var UserAgent (default, default) : String;
	
	/**
	 * Adds a Range header to the request
	 */
	@:overload(function ( rangeSpecifier : String, range : Int ) : Void { } )
	public function AddRange( rangeSpecifier : String, from : Int, to : Int ) : Void;
}

/**
 * Contains protocol headers associated with a request or response.
 * Some common headers are considered restricted and are either exposed directly by the API (such as Content-Type) or protected by the system and cannot be changed.
 * The restricted headers are:
 * • Accept
 * • Connection
 * • Content-Length
 * • Content-Type
 * • Date
 * • Expect
 * • Host
 * • If-Modified-Since
 * • Range
 * • Referer
 * • Transfer-Encoding
 * • User-Agent
 * • Proxy-Connection
 */
@:native("System.Net.WebHeaderCollection") 
extern class WebHeaderCollection implements ICollection {
	public static function IsRestricted( headerName : String ) : Bool;

	public var AllKeys (default, never) : NativeArray< String >;
	public var Keys (default, never) : ICollection;
	
	public function Add( name : String, value : String ) : Void;
	public function Clear() : Void;
	public function Get( name : String ) : String;
	public function GetValues( header : String ) : NativeArray< String >;
	public function Set( name : String, value : String ) : Void;
	public function ToByteArray() : BytesData;
	public function Remove( name : String ) : Void;
	
	// Interface ICollection:
	var Count(default, null):Int;
	var IsSynchronized(default, null):Bool;
	var SyncRoot(default, null):Bool;
	
	function CopyTo(arr:cs.system.Array, index:Int):Void;
	function GetEnumerator():IEnumerator;
}


@:native("System.Net.WebResponse") 
extern class WebResponse {
	/*public var ContentLength (default, default) : Int;
	public var ContentType (default, default) : String;
	public var Headers (default, default) : WebHeaderCollection;
	public var ResponseUri (default, never) : String;*/
	
	public function Close() : Void;
	public function GetResponseStream() : Stream;
}

@:native("System.Net.HttpWebResponse") 
extern class HttpWebResponse extends WebResponse {
	public var CharacterSet (default, never) : String;
	public var ContentEncoding (default, never) : String;
	public var ContentLength (default, never) : haxe.Int64;
	public var ContentType (default, never) : String;
	public var Cookies (default, default) : Dynamic; // TODO: CookieCollection
	public var Headers (default, never) : WebHeaderCollection;
	public var IsMutuallyAuthenticated (default, never) : Bool;
	public var LastModified (default, never) : DateTime;
	public var Method (default, never) : String;
	public var ProtocolVersion (default, never) : Dynamic; // TODO: Version
	public var ResponseUri (default, never) : String;
	public var Server (default, never) : String;
	public var StatusCode (default, never) : HttpStatusCode;
	public var StatusDescription (default, never) : String;
	
	public override function Close() : Void;
	public function GetResponseHeader(headerName : String) : String;
	public override function GetResponseStream() : Stream;
}

@:native("System.Net.HttpStatusCode") 
extern enum HttpStatusCode {
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

