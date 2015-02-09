/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.2
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package net.richardlord.input;

import haxe.io.Bytes;
import haxe.Log;

import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.display.DisplayObject;

/**
 * <p>Games often need to get the current state of various keys in order to respond to user input.
 * This is not the same as responding to key down and key up events, but is rather a case of discovering
 * if a particular key is currently pressed.</p>
 *
 * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code.
 * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard
 * is via the keyUp and keyDown events.</p>
 *
 * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a
 * parameter and returning a Boolean.</p>
 */
class KeyPoll
{
    private var states:Bytes;
    private var dispObj:DisplayObject;

    private var mod37BitPosition:Array<Int> = [
        32, 0, 1, 26, 2, 23, 27, 0, 3, 16, 24, 30, 28, 11, 0, 13,
        4, 7, 17, 0, 25, 22, 31, 15, 29, 10, 12, 6, 0, 21, 14, 9,
        5, 20, 8, 19, 18
    ];
    
    /**
     * Constructor
     *
     * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
     */
    public function new(displayObj:DisplayObject)
    {
        states = Bytes.alloc(32);
        dispObj = displayObj;
		
        dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
        dispObj.addEventListener(Event.ACTIVATE, activateListener);
        dispObj.addEventListener(Event.DEACTIVATE, deactivateListener);
    }

    private function keyDownListener(ev:KeyboardEvent):Void
    {
        var pos:Int = ev.keyCode >>> 3;
        states.set(pos, states.get(pos) | 1 << (ev.keyCode & 7));
    }

    private function keyUpListener(ev:KeyboardEvent):Void
    {
        var pos:Int = ev.keyCode >>> 3;
        states.set(pos, states.get(pos) & ~(1 << (ev.keyCode & 7)));
    }

    private function activateListener(ev:Event):Void
    {
        for (i in 0...8)
            states.set(i, 0);
    }

    private function deactivateListener(ev:Event):Void
    {
        for (i in 0...8)
            states.set(i, 0);
    }

    /**
     * To test whether a key is down.
     *
     * @param keyCode code for the key to test.
     *
     * @return true if the key is down, false otherwise.
     *
     * @see isUp
     */

    public function isDown(keyCode:Int):Bool
    {
        return ( states.get(keyCode >>> 3) & (1 << (keyCode & 7)) ) != 0;
    }

    /**
     * To test whether a key is up.
     *
     * @param keyCode code for the key to test.
     *
     * @return true if the key is up, false otherwise.
     *
     * @see isDown
     */

    public function isUp(keyCode:Int):Bool
    {
        return ( states.get(keyCode >>> 3) & (1 << (keyCode & 7)) ) == 0;
    }
    
    /**
     * Get a list of keys that are down.
     *
     * @returns A list of keyCodes for each key down.
     */
    public function getKeysDown():Array<Int> {
        var keyCodes:Array<Int> = new Array<Int>();
        var v:Int;

        for (i in 0...states.length) {
            v = states.get(i);

            while(v != 0) {
                keyCodes.push( (mod37BitPosition[(-v & v) % 37]) + (i << 3) );
                v &= v - 1;     // Clear least significant bit set
            }

        }

        return keyCodes;
    }
}
