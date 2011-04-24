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
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.managers.SoundManager;
    import com.jessefreeman.factivity.state.AbstractStateObject;

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

        public function get playerLevel():int
        {
            return _dataObject.playerLevel;
        }

        public function set playerLevel(value:int):void
        {
            _dataObject.playerLevel = value;
        }

        public function get playerLife():int
        {
            return _dataObject.playerLife;
        }

        public function set playerLife(value:int):void
        {
            _dataObject.playerLife = value;
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

        public function get score():int
        {
            return _dataObject.score;
        }

        public function set score(value:int):void
        {
            _dataObject.score = value;
        }

        public function get levelTurns():int
        {
            return _dataObject.levelTurns;
        }

        public function set levelTurns(value:int):void
        {
            _dataObject.levelTurns = value;
        }

        override public function clear():void
        {

            super.clear();
            _dataObject.bestBonus = 0;
            _dataObject.playerLife = 0;
            _dataObject.levelTurns = 0;
            _dataObject.score = 0;
            _dataObject.turns = 0;
            _dataObject.playerLevel = 0;
            _dataObject.activeGame = false;
            _dataObject.mute = soundManager.mute;
        }

        public function set bestBonus(value:int):void
        {
            if (value > _dataObject.bestBonus)
                _dataObject.bestBonus = value;
        }

        public function get bestBonus():int
        {
            return _dataObject.bestBonus;
        }
    }
}
