package haxe;

import cs.io.NativeInput;
import cs.system.DateTime;
import cs.system.IAsyncResult;
import cs.system.io.Stream;
import cs.system.net.HttpWebRequest;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Output;
import haxe.HttpStatusCode;

using StringTools;

@:allow(haxe.Http) 
class HttpResponse {
	public var headers(default, null) : Map<String,String>;
	public var data(default, null) : Null<String>;
	/**
		The http status code returned from the server.
	**/
	public var status(default, null) : HttpStatusCode;
	public var error(default, null) : Null<String>;
	
	private function new() {
		data = null;
		headers = null;
		status = HttpStatusCode.NotSet;
		error = null;
	}
	
	public function toString() {
		var str = "HttpResponse {";
		str +=     "\n     status: " + status;
		if (headers != null) {
			str += "\n    headers: " + headers.toString();
		}
		if (data != null) {
			str += "\n       data: " + data;
		}
		if (error != null) {
			str += "\n      error: " + error;
		}
		str += "\n}";
		return str;
	}
}

@:nativeGen class Http {
	
	/**
		The url of `this` request. It is used only by the request() method and
		can be changed in order to send the same request to different target
		Urls.
	**/
	public var url : String;
	public var response : HttpResponse;
	public var cnxTimeout : Float;
	public var async : Bool;
	
	var chunk_size : Null<Int>;
	var chunk_buf : haxe.io.Bytes;
	var file : { param : String, filename : String, io : haxe.io.Input, size : Int };
	var postData : String;
	var headers : haxe.ds.StringMap<String>;
	var params : haxe.ds.StringMap<String>;
	
	// TODO: public static var PROXY : { host : String, port : Int, auth : { user : String, pass : String } } = null;
	
	/**
		Creates a new Http instance with `url` as parameter.

		This does not do a request until request() is called.

		If `url` is null, the field url must be set to a value before making the
		call to request(), or the result is unspecified.

		(Php) Https (SSL) connections are allowed only if the OpenSSL extension
		is enabled.
	**/
	public function new( url : String ) {
		this.url = url;
		headers = new haxe.ds.StringMap();
		params = new haxe.ds.StringMap();
		async = true;
		cnxTimeout = 10;
		
		trace ( haxe.HttpStatusCode.Continue );
		trace ( HttpStatusCode.toString( haxe.HttpStatusCode.Conflict ) );
	}
	
	/**
		Sets the header identified as `header` to value `value`.

		If `header` or `value` are null, the result is unspecified.

		This method provides a fluent interface.
	**/
	public function setHeader( header : String, value : String ):Http {
		headers.set(header, value);
		return this;
	}
	
	/**
		Sets the parameter identified as `param` to value `value`.

		If `param` or `value` are null, the result is unspecified.

		This method provides a fluent interface.
	**/
	public function setParameter( param : String, value : String ):Http {
		params.set(param, value);
		return this;
	}
	
	/**
		Sets the post data of `this` Http request to `data`.

		There can only be one post data per request. Subsequent calls overwrite
		the previously set value.

		If `data` is null, the post data is considered to be absent.

		This method provides a fluent interface.
	**/
	public function setPostData( data : String ):Http {
		if ( data != null && file != null ) {
			throw "User either postData or fileTransfert";
		}
		postData = data;
		return this;
	}
	
	/**
		Sends `this` Http request to the Url specified by `this.url`.

		If `post` is true, the request is sent as POST request, otherwise it is
		sent as GET request.

		Depending on the outcome of the request, this method calls the
		onStatus(), onError() or onData() callback functions.

		If `this.url` is null, the result is unspecified.

		If `this.url` is an invalid or inaccessible Url, the onError() callback
		function is called.

		If `this.async` is false, the callback functions are called before
		this method returns.
	**/
	public function request( ?post : Bool ) : Void {
		var me = this;
		var output = new haxe.io.BytesOutput();
		customRequest(post, output);
	}
	
	public function fileTransfert( argname : String, filename : String, file : haxe.io.Input, size : Int ) : Void {
		if ( postData != null ) {
			throw "User either postData or fileTransfert";
		}
		this.file = { param : argname, filename : filename, io : file, size : size };
	}
	
	public function customRequest( post : Bool, api : haxe.io.Output, ?method : String  ) : Void {
		this.response = new HttpResponse();
		
		// build request:
		var request : HttpWebRequest = null;
		{
			var requestUrl = url;
			
			if ( postData != null || file != null) {
				post = true;
			}
			
			// param
			{
				var paramString = null;
				var paramKeys = params.keys();
				if ( file == null && paramKeys.hasNext() ) {
					var key = paramKeys.next();
					paramString = key.urlEncode() + "=" + params.get(key).urlEncode();
					for (key in paramKeys) {
						requestUrl += "&" + key.urlEncode() + "=" + params.get(key).urlEncode();
					}
				}
				
				if ( !post || postData != null ) {
					if ( requestUrl.indexOf("?") == -1 ) {
						requestUrl += "?" + paramString;
					} else {
						requestUrl += "&" + paramString;
					}
				} else if ( postData == null ) {
					postData = paramString;
				}
			}
			
			try {
				request = cast WebRequest.Create( requestUrl );
				request.Timeout = Math.round( 1000 * cnxTimeout );
				
				// headers
				for ( key in headers.keys() ) {
					if ( ! WebHeaderCollection.IsRestricted( key ) ) {
						request.Headers.Add( key, headers.get(key) );
					}
				}
				
				// restricted headers
				{
					if ( headers.exists( "Accept" ) )
						request.Accept = headers.get( "Accept" );
					if ( headers.exists( "Connection" ) )
						request.Connection = headers.get( "Connection" );
					if ( headers.exists( "Content-Length" ) )
						request.ContentLength = Std.parseInt( headers.get( "Content-Length" ) );
					if ( headers.exists( "Content-Type" ) )
						request.ContentType = headers.get( "Content-Type" );
					if ( headers.exists( "Date" ) )
						throw "Date header is set by system.";
					if ( headers.exists( "Expect" ) )
						request.Expect = headers.get( "Expect" );
					if ( headers.exists( "Host" ) )
						throw "Host header is set by system.";
					if ( headers.exists( "If-Modified-Since" ) )
						request.IfModifiedSince = DateTime.Parse( headers.get( "If-Modified-Since" ) );
					if ( headers.exists( "Range" ) ) {
						var range_regexp = ~/^([a-zA-Z\.0-9-]+)\w*(=\w*([\+\-]?[0-9]+)(\-([\-\+]?[0-9]+))?)/;
						if ( range_regexp.match( headers.get( "Range" ) ) ) {
							if ( range_regexp.matched(4) == null ) {
								request.AddRange( range_regexp.matched(1), Std.parseInt( range_regexp.matched(3) ) );
							} else {
								request.AddRange( range_regexp.matched(1), Std.parseInt( range_regexp.matched(3) ), Std.parseInt( range_regexp.matched(4) ));
							}
						} else {
							throw "Incorrect Range header.";
						}
					}
					if ( headers.exists( "Referer" ) )
						request.Referer = headers.get( "Referer" );
					if ( headers.exists( "Transfer-Encoding" ) ) {
						request.SendChunked = true;
						request.TransferEncoding = headers.get( "Transfer-Encoding" );
					}
					if ( headers.exists( "User-Agent" ) )
						request.UserAgent = headers.get( "User-Agent" );
					if ( headers.exists( "Proxy-Connection" ) )
						throw "Not implemented.";
				}
				
				
				// method
				if ( method != null ) {
					request.Method = method;
				} else if ( post ) {
					request.Method = HttpWebRequestMethods.Post;
				} else {
					request.Method = HttpWebRequestMethods.Get;
				}
				
				var boundary : String = null;
				var data : Bytes = null;
				if ( file != null ) {
					var b = new BytesOutput();
					
					boundary = Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000));
					while( boundary.length < 38 )
						boundary = "-" + boundary;
					
					request.ContentType = "multipart/form-data; boundary=" + boundary;
					request.KeepAlive = true;
					var requestStream = request.GetRequestStream();
					
					var b = new BytesOutput();
					for( p in params.keys() ) {
						b.writeString("--");
						b.writeString(boundary);
						b.writeString("\r\n");
						b.writeString('Content-Disposition: form-data; name="');
						b.writeString(p);
						b.writeString('"');
						b.writeString("\r\n");
						b.writeString("\r\n");
						b.writeString(params.get(p));
						b.writeString("\r\n");
					}
					b.writeString("--");
					b.writeString(boundary);
					b.writeString("\r\n");
					b.writeString('Content-Disposition: form-data; name="');
					b.writeString(file.param);
					b.writeString('"; filename="');
					b.writeString(file.filename);
					b.writeString('"');
					b.writeString("\r\n");
					b.writeString("Content-Type: " + "application/octet-stream" + "\r\n" + "\r\n");
					
					data = b.getBytes();
					//request.ContentLength = b.length + file.size + boundary.length + 6;
					request.ContentLength = data.length + file.size + boundary.length + 6;
				}
				else {
					request.ContentType = "application/x-www-form-urlencoded";
					
					if (postData != null) {
						data = Bytes.ofString(postData);
						request.ContentLength = postData.length;
						trace ( "postData.length: " + postData.length );
						trace ( "  ContentLenght: " + request.ContentLength );
						trace ( "    data.length: " + data.length );
						trace ( postData );
						trace ( "" );
						trace ( data.toString );
					}
				}
				
				if (async) {
					if (data != null) {						
						var result = request.BeginGetRequestStream( untyped __cs__("new System.AsyncCallback( getAsyncRequestStream )"), { request : request, data : data, boundary : boundary, api : api } );
						
						if (result.CompletedSynchronously) {
							getAsyncRequestStream(result);
						}
					} else {
						var result = request.BeginGetResponse( untyped __cs__("new System.AsyncCallback( getAsyncResponse )"), { request : request, api : api } );
						
						if (result.CompletedSynchronously) {
							//result.AsyncState = { request : request, api : api };
							getAsyncResponse(result);
						}
					}
				}
				else {
					if (data != null) {
						sendRequestData( request.GetRequestStream(), data, boundary );
						getResponse( request, api );
					} else {
						getResponse( request, api );
					}
				}
				
			} catch ( ex: Dynamic ) {
				response.error = Std.string(ex);
				onError( response );
			}
		}
	}
	
	function getAsyncRequestStream( asyncResult : IAsyncResult ) : Void {
		try {
			var state : { request : HttpWebRequest, data : Bytes, boundary : String, api : Output } = asyncResult.AsyncState;
			sendRequestData( state.request.EndGetRequestStream( asyncResult ), state.data, state.boundary );
			
			var result = state.request.BeginGetResponse( untyped __cs__("new System.AsyncCallback( getAsyncResponse )"), state );
			
			if (result.CompletedSynchronously) {
				//result.AsyncState = { request : request, api : api };
				getAsyncResponse(result);
			}
	} catch (ex : Dynamic) {
			response.error = Std.string(ex);
			onError( response );
		}
	}
	function sendRequestData( rs : Stream, data : Bytes, boundary : String ) {
		try {
			rs.Write( data.getData(), 0, data.length );
			
			if (file != null) {
				var bufsize = 4096;
				var buf = haxe.io.Bytes.alloc(bufsize);
				while( file.size > 0 ) {
					var size = if( file.size > bufsize ) bufsize else file.size;
					var len = 0;
					try {
						len = file.io.readBytes(buf,0,size);
					} catch( e : haxe.io.Eof ) break;
					rs.Write( buf.getData(), 0, len );
					file.size -= len;
				}
				rs.Write( Bytes.ofString( "\r\n--" + boundary + "--" ).getData(), 0, boundary.length + 6 );
			}
			rs.Close();
			
		} catch (ex : Dynamic) {
			try rs.Close() catch (e:Dynamic) { }
			response.error = Std.string(ex);
			onError( response );
		}
	}
	
	function getAsyncResponse(asyncResult : IAsyncResult) {
		var state : { request : HttpWebRequest, api : Output } = asyncResult.AsyncState;
		var nativeResponse : HttpWebResponse = null;
		try {
			nativeResponse = cast state.request.EndGetResponse(asyncResult);
			readHttpResponse ( nativeResponse, state.api );
		} catch (ex : Dynamic) {
			try nativeResponse.Close() catch ( e : Dynamic ) { };
			response.error = Std.string(ex);
			onError( response );
		}
	}
	
	function getResponse( request : HttpWebRequest, api : haxe.io.Output ) : Void {
		var nativeResponse : HttpWebResponse = null;
		try {
			nativeResponse = cast request.GetResponse();
			readHttpResponse ( nativeResponse, api );
		} catch( ex : Dynamic ) {
			try nativeResponse.Close() catch ( e : Dynamic ) { };
			response.error = Std.string(ex);
			onError( response );
		}
	}
	
	function readHttpResponse( nativeResponse : HttpWebResponse, api : Output ) : Void {
		try {
			response.status = nativeResponse.StatusCode;
			if ( response.status == HttpStatusCode.Unauthorized ) {
				trace ( "Authorization HEADER: " + nativeResponse.GetResponseHeader("Authorization"));
			}
			onStatus( response.status );
			
			response.headers = new Map();
			var headers = nativeResponse.Headers.AllKeys;
			for (i in 0...headers.Length) {
				response.headers.set( headers[i], nativeResponse.GetResponseHeader( headers[i] ) );
			}
			
			var size : Int = Int64.toInt( nativeResponse.ContentLength );
			
			var input = new NativeInput( nativeResponse.GetResponseStream() );
			
			var bufsize = 1024;
			var buf = haxe.io.Bytes.alloc(bufsize);
			if( size == -1 ) {
				try {
					while( true ) {
						var len = input.readBytes( buf,0,bufsize );
						api.writeBytes( buf, 0, len );
					}
				} catch( e : haxe.io.Eof ) {
				}
			} else {
				api.prepare( size );
				try {
					while( size > 0 ) {
						var len = input.readBytes( buf, 0, ((size > bufsize) ? bufsize : size) );
						api.writeBytes(buf,0,len);
						size -= len;
					}
				} catch( e : haxe.io.Eof ) {
					throw "Transfert aborted";
				}
			}
			//if( status < 200 || cast status >= 400 )
			//	throw "Http Error #"+ status;
			api.close();
			
			if (Std.is( api, BytesOutput )) {
				response.data = cast( api, BytesOutput ).getBytes().toString();
			}
		} catch (ex : Dynamic) {
			response.error = Std.string( ex );
			onError( response );
			return;
		}
		onData( response );
	}

	public dynamic function onData( data : String ) {
	}

	public dynamic function onError( msg : String ) {
	}

	public dynamic function onStatus( status : HttpStatusCode ) {
	}
	
	public static function requestUrl( url : String, ?params : Map<String, String>, ?headers : Map<String, String> ) : HttpResponse {
		var h = new Http(url);
		if (params != null) {
			h.params = params;
		}
		if (headers != null) {
			h.headers = headers;
		}
		
		h.async = false;
		
		var r = null;
		h.onData = function(d){
			r = d;
		}
		h.onError = function(e){
			throw e;
		}
		h.request(false);
		return r;
	}
}
