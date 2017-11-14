package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author CreateWave Oofuchiwaki
	 */
	public class Drop extends MovieClip 
	{
		public var swfFileArray:Array;
		public function Drop() 
		{
			if (stage)
			{
				onStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE , onStage);
			}
		}
		
		private function onStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			this.x = this.y = 20;
			DropSet();
		}
		
		private function DropSet():void
		{
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragEnterFunc);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragOverFunc);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragExitFunc);
			this.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, DragDropFunc);
		}
		
		private function DragDropFunc(e:NativeDragEvent):void
		{
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragEnterFunc);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragOverFunc);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, DragExitFunc);
			this.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, DragDropFunc);
			
			var clipboard:Clipboard = e.clipboard;
			
			// ファイル形式
			if (clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//trace("ファイル形式です。");
				var files:Object = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
				
				swfFileArray = [];
				for (var i:int = 0 ; i < files.length ; i++)
				{
					var file:File = files[i];
					if (file.isDirectory)
					{
						//フォルダは無視
					}
					else
					{
						var ext:String = file.extension.toLowerCase(); //拡張子
						var swfPath:String = file.nativePath;
						//var swfPathArray:Array = swfPath.split("\\");
						if (ext == "swf")
						{
							swfFileArray.push(swfPath);
						}
					}
				}
				
				if (swfFileArray.length == 0)
				{
					DropSet();
				}
				else
				{
					dispatchEvent(new Event("get_swfpath"));
				}
			}
		
		}
		
		private function DragEnterFunc(e:NativeDragEvent):void
		{
			var clipboard:Clipboard = e.clipboard;
			
			// ドロップを許可
			NativeDragManager.acceptDragDrop(this);
			//trace("ドロップの境界内に入った (format:" + String(clipboard.formats) + ")");
		}
		
		private function DragOverFunc(e:NativeDragEvent):void
		{
			var clipboard:Clipboard = e.clipboard;
			
			// ドロップを許可
			//trace("ドロップの範囲内にいる");
		}
		
		private function DragExitFunc(e:NativeDragEvent):void
		{
			var clipboard:Clipboard = e.clipboard;
			
			// ドロップを許可
			//trace("ドロップの範囲内から出た");
		}
		
		public function destroy():void
		{
			swfFileArray = null;
		}
	}

}