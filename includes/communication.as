//All those functions are called by the GUI and run the twin function inside the Character class.
//Because Flash creates a new Function object every time a function is saved inside an object,
//those functions are necessary, as they only need to be set once.

//Contact me if you have a better solution.


private function setWeapon(weaponClass:Class, armPos:int)
{
	mainChar.setWeapon(weaponClass, armPos);
}

private function cycle(partNames:Array, ID:int, increment:int = 1):void
{
	mainChar.cycle(partNames, ID, increment);
}

private function toggleItem(itemName:String):void
{
	mainChar.toggleItem(itemName);
}

private function clearEquipment():void
{
	mainChar.clearEquipment();
}

private function setProperty(property:String, value:*)
{
	mainChar[property] = value;
}
