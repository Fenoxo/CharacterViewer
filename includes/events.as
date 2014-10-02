/**
 * The single remaining stage listeners is set here.
 * Man, it used to be such a fucking jungle.
 */
public function initListeners():void
{
	stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
}

/**
* Returns the closest number to input that is inside the [min; max] interval.
* Returns min if min > max.
*/
public function lim(value:Number, min:Number, max:Number):Number
{
	value = Math.max(value,min);
	value = Math.min(value,max);
	return value;
}

/**
 * Manages NoteEvents dispatched by characters.
 * @param	NoteEvent
 */
public function onNewNoteEvent(event:NoteEvent)
{
	notes.toNote(event.noteText, event.isToAdd);
}

/**
 * Toggles the state of the full screen mode.
 * Only works if the website allows fullscreen.
 * @param	MouseEvent
 */
public function toggleFullScreen(event:MouseEvent):void
{
	if (!stage.allowsFullScreen)
	{
		notes.toNote("Looks like fullscreen is not allowed on this website. You can contact the moderator if you need it though, or download the flash and use the projector.");
	}
	else if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE || stage.displayState == StageDisplayState.FULL_SCREEN)
	{
		stage.displayState = StageDisplayState.NORMAL;
	}
	else
	{
		stage.displayState = StageDisplayState.FULL_SCREEN;
	}
}

/**
 * Sets the resolution to a multiple of the actual character resolution.
 * Triggered on ENTER_FRAME to make sure the size is alway correct.
 * @param	Event
 */
public function onResoSlide(event:SliderEvent):void
{
	capScale = event.value;
}

/**
 * Sets the fps to the value of the fps slider.
 * @param	Event
 */
public function onFpsSlide(event:SliderEvent):void
{
	stage.frameRate = event.value;
}

/**
 * Removes the target of the mouse event.
 * Triggered on double click.
 * @param	MouseEvent
 */
public function onDoubleClick(event:MouseEvent):void
{
	MCUtils.remove(event.target as Sprite);
}

/**
 * Starts dragging the target, and hide the mouse.
 * Triggered on MOUSE_DOWN
 * @param	MouseEvent
 */
public function onGrab(event:MouseEvent):void
{
	dragTarget = event.target as Sprite;
	Mouse.hide();
	dragTarget.startDrag();
}

/**
 * Stops dragging the target, and show the mouse.
 * If the target is a Character and the target's center
 * is dropped outside of the view rectangle, then
 * it will move it to the closest point inside.
 * Triggered on MOUSE_UP
 * @param	MouseEvent
 */
public function onDrop(event:MouseEvent):void
{
	if (dragTarget)
	{
		Mouse.show();
		dragTarget.stopDrag();
		
		if (dragTarget is Character)
		{
			var dragChar:Character = dragTarget as Character;
			
			dragChar.middleX = lim(dragChar.middleX, 200, 1424);
			dragChar.middleY = lim(dragChar.middleY, 0, 980);
		}
		else
		{
			var _x:Number = dragTarget.x;
			var _y:Number = dragTarget.y;
			
			if (_x < 200 || _x > 1424 || _y < 0 || _y > 980)
			{
				dragTarget.parent.removeChild(dragTarget);
			}
		}
		dragTarget = null;
	}
}

/**
 * Moves the target behind or in front of a
 * display object it is in contact with.
 * Triggered on scroll.
 * @param	MouseEvent.
 */
public function onWheel(event:MouseEvent):void
{
	var tar:Character = event.target as Character;
	var par:Sprite = tar.parent as Sprite;
	var ind:int = par.getChildIndex(tar);
	var inc:int = -lim(event.delta, -1, 1);
	if (inc == 0) return;
	
	for (var i = ind + inc; i >= 0 && i < par.numChildren; i += inc)
	{
		if (tar.hitTestObject(par.getChildAt(i)))
		{
			par.setChildIndex(tar, i);
			return;
		}
		if (i == 0 || i == par.numChildren - 1)
		{
			par.setChildIndex(tar, i);
		}
	}
}

/**
 * Change the target of a cock slider. The cock slider will affect a different cock,
 * if one is selected, and the selected cock will be slightly redder.
 * @param	The data array of the selected cock.
 * @param	If there is multiple cocks to choose from.
 */
public function cockChanger(data:Array):void
{
	var index:int = data[0];
	var value:Number = data[1];
	var slider:ViewerSlider = cockSlider;
	
	if (cockSliderTarget)
	{
		cockSliderTarget.transform.colorTransform = new ColorTransform();
	}
	if (index >= 0)
	{
		var part:MovieClip = mainChar.getPart(mainChar.cockNames[index]);
		
		slider.setSlider(27.0, lim(value, 27.0, 46.0));
		
		slider.enabled = true;
		slider.value = part.MC.scaleX * 27.0;
		slider.label = "Cock " + (index + 1) + " lenght: Xin.";
		
		part.transform.colorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0, 70.0);
		cockSliderTarget = part;
	}
	else
	{
		slider.enabled = false;
		slider.label = "";
		boobSliderTarget = null;
	}
}

/**
 * Change the target of a boob slider. The boob slider will affect a different row,
 * if one is selected, and the selected boob row will be slightly redder.
 * @param	The data array of the selected row.
 * @param	If there is multiple rows to choose from.
 */
public function boobChanger(data:Array):void
{
	var index:int = data[0];
	var value:Number = data[1];
	var slider:ViewerSlider = boobSlider;
	
	if (boobSliderTarget)
	{
		boobSliderTarget.transform.colorTransform = new ColorTransform();
	}
	if (index >= 0)
	{
		var part:MovieClip = mainChar.getPart(mainChar.boobNames[index]);
		
		slider.setSlider(80.0, lim(value, 80.0, 100));
		
		slider.enabled = true;
		slider.value = (part.MC.scaleX + 1) * 40.0;
		slider.label = "Row " + (index + 1) + " rating: X/100";
		
		part.transform.colorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0, 70.0);
		boobSliderTarget = part;
	}
	else
	{
		slider.enabled = false;
		slider.label = "";
		boobSliderTarget = null;
	}
}

/**
 * Sets the size of a cock to the value of the cock slider.
 * @param	SliderEvent
 */
public function onCockSlide(event:SliderEvent):void
{
	MCUtils.scale(cockSliderTarget.MC, event.value / 27.0);
	mainChar.updateShader();
}

/**
 * Sets the size of a boob row to the value of the boob slider.
 * @param	SliderEvent
 */
public function onBoobSlide(event:SliderEvent):void
{
	MCUtils.scale(boobSliderTarget.MC, event.value / 40.0 - 1.0);
	mainChar.updateShader();
}

/**
 * Sets the ball size to the value of the balls slider.
 * @param	SliderEvent
 */
public function onBallSlide(event:SliderEvent):void
{
	var balls:MovieClip = mainChar.getPart("balls");
	var scale:MovieClip = balls.MC as MovieClip;
	MCUtils.scale(scale, event.value / 7.0);
	mainChar.updateShader();
}

/**
 * Sets the slit size to the value of the clit slider.
 * @param	SliderEvent
 */
public function onClitSlide(event:SliderEvent):void
{
	var clit:MovieClip = mainChar.getPart("clit");
	MCUtils.scale(clit.MC, event.value / 8.0);
	mainChar.updateShader();
}

/**
 * Sets the character scaling to the value of the size slider.
 * @param	SliderEvent
 */
public function onTallSlide(event:SliderEvent):void
{
	MCUtils.scaleTargetFrom(mainChar as DisplayObject,
							event.value / 82,
							mainChar.standingPoint);
	
	mainChar.properties.heightMod = 82 / event.value;
}

/**
 * Remove any filter from focusTarget.
 * Adds a glow filter to the target, and sets focusTarget as the target.
 * Triggered on any focus shift.
 * @param	FocusEvent
 */
/*public function onFocus(event:FocusEvent):void
{
	if (focusTarget)
	{
		focusTarget.filters = [];
	}
	if (stage.focus)
	{
		focusTarget = stage.focus;
		trace("Showing focus on: " + focusTarget.name);//				0x856032
		focusTarget.filters = [new GlowFilter((isTiTS) ? 0xFFFFFF : 0x000000, 1, 7, 7, 2, 3, isTiTS)];
	}
}*/

/**
 * If the user pressed enter, simulate click on focusTarget.
 * If the user pressed escape, remove any filter from focusTarget,
 * and sets focus target to null.
 * Triggered on key press.
 * @param	KeyboardEvent
 */
/*public function onKeyPressed(event:KeyboardEvent):void
{
	if (focusTarget && event.keyCode == 13)
	{
		focusTarget.dispatchEvent(new MouseEvent(ButtonEvent.CLICK));
	}
	if (focusTarget && event.keyCode == 27)
	{
		focusTarget.filters = [];
		focusTarget = null;
	}
}*/