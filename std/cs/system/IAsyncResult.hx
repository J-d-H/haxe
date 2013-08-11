package cs.system;

@:native("System.AsyncCallback")
extern class AsyncCallback {
	public function new (asyncResult : IAsyncResult -> Void);
}

@:native("System.IAsyncResult") 
extern class IAsyncResult {
	public var AsyncState (default, never) : Dynamic;
	public var CompletedSynchronously (default, never) : Bool;
	public var IsCompleted (default, never) : Bool;
}
