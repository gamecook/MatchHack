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

package com.gamecook.matchhack.effects
{
    import com.jessefreeman.factivity.threads.GreenThread;

    import flash.display.DisplayObject;

    public class Quake extends GreenThread
    {
        private var _target:DisplayObject;

        public function Quake(target:DisplayObject, intensity:Number = 0.05, duration:Number = 0.5, updateCallback:Function = null, finishCallback:Function = null)
        {
            super(updateCallback, finishCallback);
            defaultIntensity = intensity;
            defaultTime = duration * 1000;
            this._target = target;
        }

        /**
         * The intensity of the quake effect: a percentage of the screen's size.
         */
        protected var _intensity:Number;
        private var _defaultIntensity:Number;
        /**
         * Set to countdown the quake time.
         */
        protected var _timer:Number;
        private var _defaultTime:Number;

        /**
         * The amount of X distortion to apply to the screen.
         */
        public var x:int;
        /**
         * The amount of Y distortion to apply to the screen.
         */
        public var y:int;
        private var defaultX:int;
        private var defaultY:int;


        /**
         * Reset and trigger this special effect.
         *
         * @param    intensity    Percentage of screen size representing the maximum distance that the screen can move during the 'quake'.
         * @param    duration    The length in seconds that the "quake" should last.
         */
        override public function start():void
        {
            super.start();
            clearValues();
        }

        /**
         * Stops this screen effect.
         */
        override protected function finish():void
        {
            clearValues();
            super.finish();
        }

        private function clearValues():void
        {
            x = defaultX;
            y = defaultY;
            _intensity = _defaultIntensity;
            _timer = _defaultTime;
        }

        /**
         * Runs the Quake thread
         */
        override public function run(elapsed:Number = 0):void
        {
            if (_timer > 0) {
                _timer -= elapsed;
                if (_timer <= 0) {
                    _timer = 0;
                    _target.x = defaultX;
                    _target.y = defaultY;
                }
                else {
                    _target.x = defaultX + (Math.random() * _intensity * _target.width * .5);
                    _target.y = defaultY + (Math.random() * _intensity * _target.height * .5);
                }
            }
            else {
                finish();
            }
        }

        public function set defaultIntensity(value:Number):void
        {
            _defaultIntensity = value;
        }

        public function set defaultTime(value:Number):void
        {
            _defaultTime = value;
        }

        public function get target():DisplayObject
        {
            return _target;
        }

        public function set target(value:DisplayObject):void
        {
            _target = value;
            defaultX = _target.x;
            defaultY = _target.y;
        }
    }
}
