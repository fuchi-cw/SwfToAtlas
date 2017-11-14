package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	/**
	 * ...
	 * @author CreateWave Oofuchiwaki
	 */
	public class Main extends MovieClip
	{
		public var swfFileArray:Array; //複数のSWFファイルに対応（のつもり）
		private var drop:Drop;
		private var loader:Loader = new Loader();
		private var swf_mc:MovieClip;
		
		private var swfWidth:int = 256;
		private var swfHeight:int = 256;
		private var swfAddX:int = 0;
		private var swfAddY:int = 0;
		private var swfFrame:int = 0;
		
		private var save_folder:File;
		private var atalasNo:int = 0;
		private var swfFileName:String;
		
		private var sprite:Sprite;
		private var frameCount:int = 0;
		
		public function Main()
		{
			if (stage)
			{
				onStage();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}
		
		private function onStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			DropStart();
		}
		
		private function DropStart():void
		{
			drop = new Drop();
			drop.addEventListener("get_swfpath", onGetSWFPath);
			addChild(drop);
		}
		
		private function onGetSWFPath(e:Event):void
		{
			drop.removeEventListener("get_swfpath", onGetSWFPath);
			
			swfWidth = parseInt(drop.width_txt.text);
			swfHeight = parseInt(drop.height_txt.text);
			swfFrame = parseInt(drop.frame_txt.text);
			
			swfFileArray = drop.swfFileArray;
			removeChild(drop);
			drop.destroy();
			drop = null;
			
			onSwfCapture();
		}
		
		private function onSwfCapture():void
		{
			if (swfFileArray.length > 0)
			{
				var swfPath:String = swfFileArray.shift();
				var swfPathArray:Array = swfPath.split("\\");
				swfFileName = swfPathArray[swfPathArray.length - 1].split(".")[0];
				
				//FileStreamでSWFを読みこんでみる
				var loadSwffile:File = new File(swfPath);
				var fileStream:FileStream = new FileStream();
				fileStream.open(loadSwffile, FileMode.READ);
				var byteArray:ByteArray = new ByteArray();
				fileStream.readBytes(byteArray, 0, fileStream.bytesAvailable);
				fileStream.close();
				
				//swfと同じ階層にAtlasフォルダを作る
				save_folder = loadSwffile.parent;
				save_folder = save_folder.resolvePath(swfFileName + "_Atlas");
				save_folder.createDirectory();
				
				//loaderContext.allowCodeImportをTrueに指定しないとエラーになる
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.allowCodeImport = true;
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoadComplete)
				loader.loadBytes(byteArray, loaderContext);
				
			}
			else
			{
				//全ファイル終了
				DropStart();
			}
		}
		
		private function swfLoadComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoadComplete);
			swf_mc = e.target.content;
			
			sprite = new Sprite();
			addChild(sprite);
			swfAddX = 0;
			swfAddY = 0;
			atalasNo = 0;
			frameCount = 0;
			
			addEventListener(Event.ENTER_FRAME, onCaptureEnter);
		}
		
		private function onCaptureEnter(e:Event):void
		{
			frameCount++;
			if (frameCount <= swfFrame)
			{
				if ((swfAddX + swfWidth) > 1024)
				{
					//横幅超えたので一段下に
					swfAddX = 0;
					swfAddY += swfHeight;
					
					if ((swfAddY + swfHeight) > 1024)
					{
						//縦も超えたので、一枚セーブ
						atalasSave();
					}
				}
				
				var bitmapData:BitmapData = new BitmapData(swfWidth, swfHeight, true, 0x00ffffff);//32ビット　透明アルファで保存
				bitmapData.draw(swf_mc);
				
				var bitMap:Bitmap = new Bitmap(bitmapData);
				bitMap.x = swfAddX;
				bitMap.y = swfAddY;
				
				sprite.addChild(bitMap);
				swfAddX += swfWidth;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, onCaptureEnter);
				atalasSave();
				onSwfCapture();
			}
		}
		
		private function atalasSave():void
		{
			var textureBitMapData:BitmapData = new BitmapData(1024, 1024, true, 0x00ffffff);//32ビット　透明アルファで保存
			textureBitMapData.draw(this.stage);
			
			var saveByteArray:ByteArray = PNGEncoder.encode(textureBitMapData);
			
			atalasNo++;
			var save_fileName:String = swfFileName + "_" + atalasNo + ".png";
			
			var save_file:File = save_folder.resolvePath(save_fileName);
			var fsw:FileStream = new FileStream();
			fsw.open(save_file, FileMode.WRITE);
			fsw.writeBytes(saveByteArray, 0, saveByteArray.length);
			fsw.close();
			
			//次のAtlas制作開始
			removeChild(sprite);
			sprite = new Sprite();
			addChild(sprite);
			swfAddX = 0;
			swfAddY = 0;
		}
	}
}