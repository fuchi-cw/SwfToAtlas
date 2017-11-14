package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.events.NativeDragEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Oofuchiwaki
	 */
	public class Drop extends MovieClip 
	{
		
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
			/*
			   // テキスト形式
			   if (clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
			   {
			   var str = clipboard.getData(ClipboardFormats.TEXT_FORMAT);
			   trace("テキスト形式です。");
			   }
			
			   // HTMLテキスト形式
			   if (clipboard.hasFormat(ClipboardFormats.HTML_FORMAT))
			   {
			   var html_str = clipboard.getData(ClipboardFormats.HTML_FORMAT);
			   trace("HTML形式です。");
			   }
			
			   // URLテキスト形式
			   if (clipboard.hasFormat(ClipboardFormats.URL_FORMAT))
			   {
			   var url_str = clipboard.getData(ClipboardFormats.URL_FORMAT);
			   trace("URL形式です。");
			   }
			
			   // BITMAP形式
			   if (clipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT))
			   {
			   var bmp_data = clipboard.getData(ClipboardFormats.BITMAP_FORMAT);
			   trace("ビットマップ形式です。");
			   }
			 */
			
			// ファイル形式
			if (clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//trace("ファイル形式です。");
				var files:Object = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
				
				/*
				   var i:int;
				   for (i = 0; i < files.length; i++)
				   {
				   var file:File = files[i];
				   //msg.text = "No:" + i + " Path:" + file.nativePath + "\n" + msg.text;
				   trace(file.nativePath);
				   }
				 */
				
				 /*
				if (clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT))
				{
					var str = clipboard.getData(ClipboardFormats.TEXT_FORMAT);
					//trace("テキスト形式です。");
				}
				*/
				
				
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
						var swfPathArray:Array = swfPath.split("\\");
						trace( "path : " + swfPath );
						if (ext == "swf")
						{
							trace("swfです");
							
						}
					}
				}
				
				/*
				if (files.length == 1)
				{
					//trace("ファイルの数は1個");
					var file:File = files[0];
					if (file.isDirectory)
					{
						//trace("フォルダである");
						path = file.nativePath;
						var userDirAndFiles:Array = file.getDirectoryListing();
						
						//配列の内容を一つずつフォルダかどうか調べる
						for (var i:uint = 0; i < userDirAndFiles.length; i++)
						{
							var userFile:File = userDirAndFiles[i];
							var ext:String = userFile.extension.toLowerCase(); //拡張子
							if (userFile.isDirectory)
							{
								//フォルダだったら無視
							}
							else
							{
								var url:URLRequest;
								var userFilePath:String = userFile.nativePath;
								var userFolderArray:Array = userFilePath.split("\\");
								//フィルダじゃなかったら拡張子を調べる
								if (ext == "csv" && userFolderArray[userFolderArray.length - 1] == "data.csv")
								{
									loadAll ++;
									url = new URLRequest(userFile.nativePath);
									url_loader.load(url);
								}
							}
						}
						if (loadAll <= 0)
						{
							DropSet();
						}
					}
					else
					{
						//trace("フォルダでない");
						DropSet();
					}
				}
				else
				{
					//trace(files.length);
					DropSet();
				}
				*/
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
		
	}

}