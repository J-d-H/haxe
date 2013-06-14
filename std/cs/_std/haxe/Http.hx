package haxe;

import cs.io.NativeInput;
import cs.system.DateTime;
import cs.system.io.Stream;
import cs.system.net.HttpWebRequest;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.Output;

using StringTools;

//@:coreApi 
@:nativeGen class Http {
	
	/**
		The url of `this` request. It is used only by the request() method and
		can be changed in order to send the same request to different target
		Urls.
	**/
	public var url : String;
	public var responseData(default, null) : Null<String>;
	public var cnxTimeout : Float;
	public var responseHeaders : haxe.ds.StringMap<String>;
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
		var err = false;
		var orgiOnError = onError;
		onError = function(e) {
			me.responseData = output.getBytes().toString();
			err = true;
			orgiOnError(e);
		}
		customRequest(post, output);
		if (!err)
			me.onData(me.responseData = output.getBytes().toString());
	}
	
	public function fileTransfert( argname : String, filename : String, file : haxe.io.Input, size : Int ) : Void {
		if ( postData != null ) {
			throw "User either postData or fileTransfert";
		}
		this.file = { param : argname, filename : filename, io : file, size : size };
	}
	
	public function customRequest( post : Bool, api : haxe.io.Output, ?method : String  ) : Void {
		var request : HttpWebRequest = null;
		var response : HttpWebResponse = null;
		var rs : Stream = null;
		this.responseData = null;
		
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
			
			if ( file != null ) {
				var b = new BytesOutput();
				
				var boundary = Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000))+Std.string(Std.random(1000));
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
				
				request.ContentLength = b.length + file.size + boundary.length + 6;
				
				rs = request.GetRequestStream();
				
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
				rs.Close();
			}
			else {
				request.ContentType = "application/x-www-form-urlencoded";
				
				var b = new BytesOutput();
				if ( postData != null ) {
					b.writeString(postData);
				}
				
				request.ContentLength = postData.length;
				
				if (b.length > 0) {
					rs = request.GetRequestStream();
					var data = b.getBytes().getData();
					rs.Write( data, 0, postData.length );
					rs.Close();
				}
			}
			
			response = cast request.GetResponse();
			
			readHttpResponse ( response, api );
			
		} catch( e : Dynamic ) {
			try rs.Close() catch ( e : Dynamic ) { };
			try response.Close() catch ( e : Dynamic ) { };
			onError(Std.string(e));
		}
	}
	
	function readHttpResponse( response : HttpWebResponse, api : Output ) : Void {
		var status : Int = cast response.StatusCode;
		onStatus( status );
		
		var size : Int = Int64.toInt(response.ContentLength);
		
		var input = new NativeInput( response.GetResponseStream() );
		
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
		if( status < 200 || status >= 400 )
			throw "Http Error #"+ status;
		api.close();
	}

	/**
		This method is called upon a successful request, with `data` containing
		the result String.

		The intended usage is to bind it to a custom function:
		`httpInstance.onData = function(data) { // handle result }`
	**/
	public dynamic function onData( data : String ) {
	}

	/**
		This method is called upon a request error, with `msg` containing the
		error description.

		The intended usage is to bind it to a custom function:
		`httpInstance.onError = function(msg) { // handle error }`
	**/
	public dynamic function onError( msg : String ) {
	}

	/**
		This method is called upon a Http status change, with `status` being the
		new status.

		The intended usage is to bind it to a custom function:
		`httpInstance.onStatus = function(status) { // handle status }`
	**/
	public dynamic function onStatus( status : Int ) {
	}
	
	/**
		Makes a synchronous request to `url`.

		This creates a new Http instance and makes a GET request by calling its
		request(false) method.

		If `url` is null, the result is unspecified.
	**/
	public static function requestUrl( url : String ) : String {
		var h = new Http(url);
		
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
