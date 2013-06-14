package cs.system;

typedef AsyncCallback = IAsyncResult -> Void;

@:native("System.IAsyncResult") 
extern class IAsyncResult {
	public var AsyncState (default, never) : Dynamic;
	public var CompletedSynchronously (default, never) : Bool;
	public var IsCompleted (default, never) : Bool;
}
