package mobile.psychlua;

import psychlua.CustomSubstate;
#if LUA_ALLOWED
import lime.ui.Haptic;
import psychlua.FunkinLua;
import psychlua.LuaUtils;
import mobile.backend.TouchUtil;
#if android import mobile.backend.PsychJNI; #end

/**
 * ...
 * @author: Karim Akra and Homura Akemi (HomuHomu833)
 */
class MobileFunctions {
	public static function implement(funk:FunkinLua) {
		var lua:State = funk.lua;
		Lua_helper.add_callback(lua, 'mobileC', Controls.instance.mobileC);

		Lua_helper.add_callback(lua, 'mobileControlsMode', getMobileControlsAsString());

		Lua_helper.add_callback(lua, "extraButtonPressed", (button:String) -> {
			button = button.toLowerCase();
			final hitbox = MusicBeatState.getState().hitbox;

			return switch (button) {
				case 'second': hitbox?.buttonExtra2?.pressed == true;
				default: hitbox?.buttonExtra?.pressed == true;
			};
		});

		Lua_helper.add_callback(lua, "extraButtonJustPressed", (button:String) -> {
			button = button.toLowerCase();
			final hitbox = MusicBeatState.getState().hitbox;

			return switch (button) {
				case 'second': hitbox?.buttonExtra2?.justPressed == true;
				default: hitbox?.buttonExtra?.justPressed == true;
			};
		});

		Lua_helper.add_callback(lua, "extraButtonJustReleased", (button:String) -> {
			button = button.toLowerCase();
			final hitbox = MusicBeatState.getState().hitbox;

			return switch (button) {
				case 'second': hitbox?.buttonExtra2?.justReleased == true;
				default: hitbox?.buttonExtra?.justReleased == true;
			};
		});

		Lua_helper.add_callback(lua, "extraButtonReleased", (button:String) -> {
			button = button.toLowerCase();
			final hitbox = MusicBeatState.getState().hitbox;

			return switch (button) {
				case 'second': hitbox?.buttonExtra2?.released == true;
				default: hitbox?.buttonExtra?.released == true;
			};
		});

		Lua_helper.add_callback(lua, "vibrate", (?duration:Int, ?period:Int) -> {
			if (duration == null)
				return funk.luaTrace('vibrate: No duration specified.');
			else if (period == null)
				period = 0;
			return Haptic.vibrate(period, duration);
		});

		Lua_helper.add_callback(lua, "addTouchPad", (DPadMode:String, ActionMode:String, ?addToCustomSubstate:Bool = false, ?posAtCustomSubstate:Int = -1) -> {
			PlayState.instance.makeLuaTouchPad(DPadMode, ActionMode);
			if (addToCustomSubstate) {
				if (PlayState.instance.luaTouchPad != null || !PlayState.instance.members.contains(PlayState.instance.luaTouchPad))
					CustomSubstate.insertLuaTpad(posAtCustomSubstate);
			}
			else
				PlayState.instance.addLuaTouchPad();
		});

		Lua_helper.add_callback(lua, "removeTouchPad", () -> {
			PlayState.instance.removeLuaTouchPad();
		});

		Lua_helper.add_callback(lua, "addTouchPadCamera", () -> {
			if (PlayState.instance.luaTouchPad == null) {
				funk.luaTrace('addTouchPadCamera: Touch Pad does not exist.');
				return;
			}
			PlayState.instance.addLuaTouchPadCamera();
		});

		Lua_helper.add_callback(lua, "touchPadJustPressed", function(button:Dynamic):Bool {
			if (PlayState.instance.luaTouchPad == null) {
				return false;
			}
			return PlayState.instance.luaTouchPadJustPressed(button);
		});

		Lua_helper.add_callback(lua, "touchPadPressed", function(button:Dynamic):Bool {
			if (PlayState.instance.luaTouchPad == null) {
				return false;
			}
			return PlayState.instance.luaTouchPadPressed(button);
		});

		Lua_helper.add_callback(lua, "touchPadJustReleased", function(button:Dynamic):Bool {
			if (PlayState.instance.luaTouchPad == null) {
				return false;
			}
			return PlayState.instance.luaTouchPadJustReleased(button);
		});

		Lua_helper.add_callback(lua, "touchPadReleased", function(button:Dynamic):Bool {
			if (PlayState.instance.luaTouchPad == null) {
				return false;
			}
			return PlayState.instance.luaTouchPadReleased(button);
		});

		Lua_helper.add_callback(lua, "touchJustPressed", TouchUtil.justPressed);
		Lua_helper.add_callback(lua, "touchPressed", TouchUtil.pressed);
		Lua_helper.add_callback(lua, "touchJustReleased", TouchUtil.justReleased);
		Lua_helper.add_callback(lua, "touchReleased", TouchUtil.released);
		Lua_helper.add_callback(lua, "touchPressedObject", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchPressedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj, cam) && TouchUtil.pressed;
		});

		Lua_helper.add_callback(lua, "touchJustPressedObject", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchJustPressedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj, cam) && TouchUtil.justPressed;
		});

		Lua_helper.add_callback(lua, "touchJustReleasedObject", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchJustReleasedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj, cam) && TouchUtil.justReleased;
		});

		Lua_helper.add_callback(lua, "touchReleasedObject", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchReleasedObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj, cam) && TouchUtil.released;
		});

		Lua_helper.add_callback(lua, "touchPressedObjectComplex", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchPressedObjectComplex: $object does not exist.');
				return false;
			}
			return TouchUtil.overlapsComplex(obj, cam) && TouchUtil.pressed;
		});

		Lua_helper.add_callback(lua, "touchJustPressedObjectComplex", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchJustPressedObjectComplex: $object does not exist.');
				return false;
			}
			return TouchUtil.overlapsComplex(obj, cam) && TouchUtil.justPressed;
		});

		Lua_helper.add_callback(lua, "touchJustReleasedObjectComplex", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchJustReleasedObjectComplex: $object does not exist.');
				return false;
			}
			return TouchUtil.overlapsComplex(obj, cam) && TouchUtil.justReleased;
		});

		Lua_helper.add_callback(lua, "touchReleasedObjectComplex", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchReleasedObjectComplex: $object does not exist.');
				return false;
			}
			return TouchUtil.overlapsComplex(obj, cam) && TouchUtil.released;
		});

		Lua_helper.add_callback(lua, "touchOverlapsObject", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchOverlapsObject: $object does not exist.');
				return false;
			}
			return TouchUtil.overlaps(obj, cam);
		});

		Lua_helper.add_callback(lua, "touchOverlapsObjectComplex", function(object:String, ?camera:String):Bool {
			var obj = PlayState.instance.getLuaObject(object);
			var cam:FlxCamera = LuaUtils.cameraFromString(camera);
			if (obj == null) {
				funk.luaTrace('touchOverlapsObjectComplex: $object does not exist.');
				return false;
			}
			return TouchUtil.overlapsComplex(obj, cam);
		});
	}

	public static function getMobileControlsAsString():String
		return 'hitbox';
}

#if android
class AndroidFunctions {
	// static var spicyPillow:AndroidBatteryManager = new AndroidBatteryManager();
	public static function implement(funk:FunkinLua) {
		var lua:State = funk.lua;
		// Lua_helper.add_callback(lua, "isRooted", AndroidTools.isRooted());
		Lua_helper.add_callback(lua, "isDolbyAtmos", AndroidTools.isDolbyAtmos());
		Lua_helper.add_callback(lua, "isAndroidTV", AndroidTools.isAndroidTV());
		Lua_helper.add_callback(lua, "isTablet", AndroidTools.isTablet());
		Lua_helper.add_callback(lua, "isChromebook", AndroidTools.isChromebook());
		Lua_helper.add_callback(lua, "isDeXMode", AndroidTools.isDeXMode());
		// Lua_helper.add_callback(lua, "isCharging", spicyPillow.isCharging());

		Lua_helper.add_callback(lua, "backJustPressed", FlxG.android.justPressed.BACK);
		Lua_helper.add_callback(lua, "backPressed", FlxG.android.pressed.BACK);
		Lua_helper.add_callback(lua, "backJustReleased", FlxG.android.justReleased.BACK);

		Lua_helper.add_callback(lua, "menuJustPressed", FlxG.android.justPressed.MENU);
		Lua_helper.add_callback(lua, "menuPressed", FlxG.android.pressed.MENU);
		Lua_helper.add_callback(lua, "menuJustReleased", FlxG.android.justReleased.MENU);

		Lua_helper.add_callback(lua, "getCurrentOrientation", () -> PsychJNI.getCurrentOrientationAsString());
		Lua_helper.add_callback(lua, "setOrientation", function(?hint:String):Void {
			switch (hint.toLowerCase()) {
				case 'portrait':
					hint = 'Portrait';
				case 'portraitupsidedown' | 'upsidedownportrait' | 'upsidedown':
					hint = 'PortraitUpsideDown';
				case 'landscapeleft' | 'leftlandscape':
					hint = 'LandscapeLeft';
				case 'landscaperight' | 'rightlandscape' | 'landscape':
					hint = 'LandscapeRight';
				default:
					hint = null;
			}
			if (hint == null)
				return funk.luaTrace('setOrientation: No orientation specified.');
			PsychJNI.setOrientation(FlxG.stage.stageWidth, FlxG.stage.stageHeight, false, hint);
		});

		Lua_helper.add_callback(lua, "minimizeWindow", () -> AndroidTools.minimizeWindow());

		Lua_helper.add_callback(lua, "showToast", function(text:String, ?duration:Int, ?xOffset:Int, ?yOffset:Int) /* , ?gravity:Int*/ {
			if (text == null)
				return funk.luaTrace('showToast: No text specified.');
			else if (duration == null)
				return funk.luaTrace('showToast: No duration specified.');

			if (xOffset == null)
				xOffset = 0;
			if (yOffset == null)
				yOffset = 0;

			AndroidToast.makeText(text, duration, -1, xOffset, yOffset);
		});

		Lua_helper.add_callback(lua, "isScreenKeyboardShown", () -> PsychJNI.isScreenKeyboardShown());

		Lua_helper.add_callback(lua, "clipboardHasText", () -> PsychJNI.clipboardHasText());
		Lua_helper.add_callback(lua, "clipboardGetText", () -> PsychJNI.clipboardGetText());
		Lua_helper.add_callback(lua, "clipboardSetText", function(?text:String):Void {
			if (text != null)
				return funk.luaTrace('clipboardSetText: No text specified.');
			PsychJNI.clipboardSetText(text);
		});

		Lua_helper.add_callback(lua, "manualBackButton", () -> PsychJNI.manualBackButton());

		Lua_helper.add_callback(lua, "setActivityTitle", function(text:String):Void {
			if (text != null)
				return funk.luaTrace('setActivityTitle: No text specified.');
			PsychJNI.setActivityTitle(text);
		});
	}
}
#end
#end
