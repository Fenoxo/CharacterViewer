package classes.character.layers {
	import classes.character.CharacterData;
	import classes.character.CharacterProperties;
	import com.gskinner.motion.easing.Sine;
	import com.gskinner.motion.GTweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.system.System;
	import flash.events.Event;
	import flash.events.ShaderEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.ByteArray;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * This layer generates a temporary or permanent shading bitmap.
	 * Currently, it is only used for the goo shader.
	 * 
	 * Should be changed to inherit Bitmap instead of Sprite, to save memory on cacheAsBitmap.
	 * @author Sbaf
	 */
	public class ShaderLayer extends Sprite
	{
		[Embed(source = "./../../../filters/AlphaShader.pbj", mimeType = "application/octet-stream")]
		private static var GooSkinShader:Class;
		[Embed(source = "./../../../filters/AlphaMixer.pbj", mimeType = 'application/octet-stream')]
		private static var GooSkinBlender:Class;
		
		private static var gooShader:Shader = new Shader(new GooSkinShader() as ByteArray);//The goo shader. Creates an alpha map to be used as a mask.
		private static var gooBlender:Shader = new Shader(new GooSkinBlender() as ByteArray);//The goo blender. Apply the alpha value of the mask to the BodyLayer instance.
		
		private static var tweenerTarget:Object = { shaderAlphaOffset:255 };//Tweener properties
		private static var tweenerProperty:Object = { ease:Sine.easeOut };//Tweener easing
		
		private var prop:CharacterProperties;//The character properties, to choose the right shader.
		
		private var shadingSource:Sprite;//The bodyLayer instance, used to create the alpha map.
		private var temporaryShader:Bitmap;//A temporary alpha map, holding a similar shader, but at a higher resolution, for screenshots.
		private var activeShader:Bitmap;//The usual alpha map, used for every other situation.
		private var activeTimeout:uint;//The UID of the timeout object, used to prevent the shaderJob bug.
		private var activeJob:ShaderJob;//The shadeJob that creates the required shader.
		private var alphaTransform:ColorTransform;//The transform used to create the fade-in effect.
		
		private var isValid:Boolean = true;//Boolean value used for the invalidation system.
		
		/**
		 * Creates a new ShaderLayer instance, using a target and a reference to the CharacterData object.
		 * @param	The current BodyLayer instance.
		 * @param	The current CharacterData Instance.
		 */
		public function ShaderLayer(target:Sprite, characterData:CharacterData) 
		{
			this.shadingSource = target;
			this.prop = characterData.prop;
			
			GooSkinShader = null;
			GooSkinBlender = null;
			
			visible = false;
			
			blendShader = gooBlender;
			blendMode = BlendMode.SHADER;
			
			alphaTransform = new ColorTransform();
			
			addEventListener(Event.EXIT_FRAME, onFrame, false, 0, true);
		}
		
		/**
		 * Set up the goo shader.
		 * Should be simplified and split up.
		 * @param	The resolution of the shader overlay.
		 * @param	If the shader is meant for a screenshot (higher quality and instantaneous) or normal use (lower quality, asynchronous and tweened to normal state).
		 * @throws	Error if there is already a temporary or active shader. All that behaviour should be moved here.
		 */
		public function addGooShader(scaling:Number = 1.0, isTemporary:Boolean = false):void
		{
			if (isTemporary && temporaryShader)
				throw new Error("ERROR: already one isTemporary shader. Use removeShader(true).");
			if (!isTemporary && activeShader)
				throw new Error("ERROR: already one active shader. Use removeShader(false).");
			
			var rect:Rectangle = parent.getRect(shadingSource);
			
			var input:BitmapData = new BitmapData(rect.width * scaling, rect.height * scaling, true, 0x000000);
			var result:BitmapData = new BitmapData(input.width, input.height, true, 0x000000);
			
			input.draw(shadingSource, new Matrix(scaling, 0, 0, scaling, -rect.x * scaling, -rect.y * scaling));
			gooShader.data.scaling.value = [scaling];
			gooShader.data.src.input = input;
			
			var bmp:Bitmap = new Bitmap();
			bmp.x = rect.x;
			bmp.y = rect.y;
			bmp.scaleX = 1.0 / scaling;
			bmp.scaleY = 1.0 / scaling;
			addChild(bmp);
			
			var precision:String = (isTemporary) ? "full" : "fast";
			gooShader.precisionHint = precision;
			gooBlender.precisionHint = precision;
			var job:ShaderJob = new ShaderJob(gooShader, result, input.width, input.height);
			
			if (isTemporary)
			{
				temporaryShader = bmp;
				job.start();
			}
			else
			{
				activeJob = job;
				activeShader = bmp;
				activeTimeout = setTimeout(onTimeout, 1);
			}
			visible = true;
			cacheAsBitmap = true;//!!!
			parent.cacheAsBitmap = true;
		}
		
		/**
		 * Declares the shader invalid, and removes the current shader.
		 */
		public function invalidate():void
		{
			if (isActive) 
			{
				removeShader(false);
			}
			isValid = false;
		}
		
		/**
		 * If the shader was invalidated in the last frame, creates a new one.
		 * Triggered on ENTER_FRAME.
		 * @param	event
		 */
		private function onFrame(event:Event):void
		{
			if (!isValid)
			{
				if (prop.skinType == 3)
				{
					addGooShader(82 / prop.tallness);
				}
				isValid = true;
			}
		}
		
		/**
		 * Since you cannot launch a new ShaderJob the same frame the previous job was cancelled, we need a timeout.
		 * This function will be called when the timeout ends, sets the uid to 0, and start the job.
		 */
		private function onTimeout()
		{
			clearTimeout(activeTimeout);
			activeTimeout = 0;
			activeJob.addEventListener(ShaderEvent.COMPLETE, onShadingComplete);
			activeJob.start(false);
		}
		
		/**
		 * Called when the ShaderJob finishes.
		 * It will remove the listener, set activeJob to null, and start the alpha tweening.
		 * @param	event
		 */
		private function onShadingComplete(event:ShaderEvent):void
		{
			activeJob.removeEventListener(ShaderEvent.COMPLETE, onShadingComplete);
			activeShader.bitmapData = event.bitmapData;
			activeJob = null;
			GTweener.from(this, 0.5, tweenerTarget, tweenerProperty);
		}
		
		/**
		 * Set the current shader alpha offset.
		 * At 255, the shader has no visual effect. At 0, it is fully visible.
		 */
		public function set shaderAlphaOffset(value:Number)
		{
			alphaTransform.alphaOffset = value;
			activeShader.transform.colorTransform = alphaTransform;
		}
		
		/**
		 * Get the shader alpha offset.
		 * Necessary for tweening.
		 */
		public function get shaderAlphaOffset()
		{
			return (alphaTransform.alphaOffset);
		}

		/**
		 * Hide the active shader.
		 */
		public function hideActiveShader()
		{
			activeShader.visible = false;
		}

		/**
		 * Show the active shader.
		 */
		public function showActiveShader()
		{
			activeShader.visible = false;
		}

		/**
		 * Remove and dispose of a shader.
		 * Safe to use even if the sahder is being created, during any state.
		 * @param	If the temporary or active shader should be removed.
		 */
		public function removeShader(isTemporary:Boolean = false):void
		{
			if ((isTemporary && !temporaryShader) || (!isTemporary && !activeShader))
				throw new Error("ERROR: No shader to remove.");
			
			if (isTemporary)
			{
				temporaryShader.bitmapData.dispose();
				removeChild(temporaryShader);
				temporaryShader = null;
			}
			else
			{
				if (activeTimeout)
				{
					clearTimeout(activeTimeout);
					activeTimeout = 0;
					activeJob = null;
				}
				else if (activeJob)
				{
					activeJob.cancel();
					activeJob.removeEventListener(ShaderEvent.COMPLETE, onShadingComplete);
					activeJob = null;
				}
				else
				{
					activeShader.bitmapData.dispose();
					GTweener.removeTweens(this);
				}
				this.removeChild(activeShader);
				activeShader = null;
			}
			if (numChildren == 0)
			{
				visible = false;
				parent.cacheAsBitmap = false;
			}
		}
		
		/**
		 * Returns true if there is an active shader, false elsewise.
		 */
		public function get isActive():Boolean
		{
			return (activeShader != null);
		}
		
		/**
		 * Dispose of the current active shader, removes any reference to the character, and any listeners.
		 */
		public function dispose():void
		{
			removeEventListener(Event.EXIT_FRAME, onFrame);
			
			if (activeShader)
			{
				removeShader(false);
			}
			isValid = true;
			shadingSource = null;
		}
	}
}