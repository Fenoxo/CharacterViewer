/**
 * Takes and attempt to encode a high-resolution capture of the character.
 * The resolution of the picture is set by the resolution slider.
 * Huge pictures will result in a screenshot buttons lockdown.
 * The pictures are encoded asynchronously to avoid chrashes.
 * A high-res shader will be recreated if needed, to avoid pixelated goo-girls.
 * @param	btnName
 */
private function characterCap():void
{
	lockScreenshot();
	
	if (mainChar.skinType == 3)
	{
		mainChar.addTemporaryGooShader(capScale);
	}
	
	var rect:Rectangle = mainChar.getBounds(mainChar);
	var matrix:Matrix = new Matrix(capScale, 0 , 0 , capScale, -rect.x * capScale, -rect.y * capScale);
	capBitmap = new BitmapData(rect.width * capScale, rect.height * capScale, true, 0x0);
	capBitmap.draw(mainChar, matrix);
	
	if (mainChar.skinType == 3)
	{
		mainChar.removeTemporaryShader();
	}
	
	PNGEncoder = PNGEncoder2.encodeAsync(capBitmap);
	PNGEncoder.addEventListener(Event.COMPLETE, saveCap);
}

/**
 * Takes and attempt to encode a capture of the entire screen.
 * The panels are cropped out.
 * The pictures are encoded asynchronously to avoid chrashes.
 * @param	btnName
 */
private function backgroundCap():void
{
	lockScreenshot();
	var matrix = new Matrix(1,0,0,1,-200,0);
	capBitmap = new BitmapData(1224, 980);
	capBitmap.draw(this, matrix);
	PNGEncoder = PNGEncoder2.encodeAsync(capBitmap);
	PNGEncoder.addEventListener(Event.COMPLETE, saveCap);
}

/**
 * Save a picture.
 * Triggered after a successfull PNG encoding.
 * @param	Event
 */
private function saveCap(event:Event):void
{
	PNGEncoder.removeEventListener(Event.COMPLETE, saveCap);
	try
	{
		var fileRef = new FileReference();
		fileRef.save(PNGEncoder.png, mainChar.properties.playerName + ".png");
	}
	catch (e:Error)
	{
		trace("Error:" + e);
	}
	
	PNGEncoder = null;
	capBitmap.dispose();
	unlockScreenshot();
}