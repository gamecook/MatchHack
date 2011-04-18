/*
 * Copyright (c) 2011 Jesse Freeman
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

package com.gamecook.matchhack.states
{
    import com.gamecook.matchhack.managers.SingletonManager;
    import com.gamecook.matchhack.managers.SoundManager;

    public class ActiveGameState extends AbstractStateObject
    {
        private const MATCH_HACK:String = "matchhack";
        private var soundManager:SoundManager = SingletonManager.getClassReference(SoundManager) as SoundManager;

        public function ActiveGameState()
        {
            super(this, MATCH_HACK)
        }

        public function get activeGame():Boolean
        {
            return _dataObject.activeGame;
        }

        public function set activeGame(value:Boolean):void
        {
            _dataObject.activeGame = value;
        }

        public function get playerLevel():Object
        {
            return _dataObject.playerLevel;
        }

        public function set playerLevel(value:Object):void
        {
            _dataObject.playerLevel = value;
        }

        public function get mute():Boolean
        {
            return _dataObject.hasOwnProperty("mute") ? _dataObject.mute : false;
        }

        override public function save():String
        {
            // Get global values
            _dataObject.mute = soundManager.mute;

            return super.save();
        }

        public function get difficulty():int
        {
            return _dataObject.difficulty;
        }

        public function set difficulty(value:int):void
        {
            _dataObject.difficulty = value;
        }

        public function get turns():int
        {
            return _dataObject.turns;
        }

        public function set turns(value:int):void
        {
            _dataObject.turns = value;
        }
    }
}
