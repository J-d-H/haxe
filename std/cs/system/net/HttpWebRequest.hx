package cs.system.net;

import cs.NativeArray;
import cs.system.collections.ICollection;
import cs.system.collections.IEnumerator;
import cs.system.DateTime;
import cs.system.Exception;
import cs.system.IAsyncResult;
import cs.system.io.Stream;
import haxe.HttpStatusCode;
import haxe.io.BytesData;

extern class WebException extends Exception {
	public var Status (default, never) : Dynamic;// TODO: WebExceptionStatus;
}

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
	//public var UseDefaultCredentials (default, default) : Bool;
	
	public override function Abort() : Void;
	/**
	 * Adds a Range header to the request
	 */
	@:overload(function ( rangeSpecifier : String, range : Int ) : Void { } )
	public function AddRange( rangeSpecifier : String, from : Int, to : Int ) : Void;
	
	public override function BeginGetRequestStream( callback : AsyncCallback, state : Dynamic ) : IAsyncResult;
	public override function BeginGetResponse( callback : AsyncCallback, state : Dynamic ) : IAsyncResult;
	public override function EndGetRequestStream( asyncResult : IAsyncResult ) : Stream;
	public override function EndGetResponse( asyncResult : IAsyncResult ) : WebResponse;
	override public function GetRequestStream():Stream;
	override public function GetResponse():WebResponse;
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
	public var StatusCode (default, never) : CSHttpStatusCode;
	public var StatusDescription (default, never) : String;
	
	public override function Close() : Void;
	public function GetResponseHeader(headerName : String) : String;
	public override function GetResponseStream() : Stream;
}


