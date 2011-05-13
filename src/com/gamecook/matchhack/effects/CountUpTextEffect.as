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
    import com.jessefreeman.factivity.threads.Thread;

    import flash.text.TextField;

    public class CountUpTextEffect extends Thread
    {
        private var target:TextField;
        private var value:Number;
        private var speed:int;
        private var counter:int = 0;
        private var paddedText:String;

        public function CountUpTextEffect(target:TextField, updateCallback:Function = null, finishCallback:Function = null)
        {
            this.target = target;
            super(updateCallback, finishCallback);
        }

        public function newValue(value:Number, paddedText:String = ""):void
        {
            speed = 1;
            if (value > 100)
            {
                speed = 10;
            }
            else if (value > 500)
            {
                speed = 50;
            }
            else if (value > 1000)
            {
                speed = 100;
            }

            this.paddedText = paddedText;
            this.value = value;
        }


        override public function start():void
        {
            target.text = paddedText;
            counter = 0;
            super.start();
        }

        override public function run(elapsed:Number = 0):void
        {
            super.run(elapsed);
            counter += speed;
            if (counter > value)
                counter = value;

            target.text = pad(paddedText, counter.toString());

            if (counter == value)
                finish();
        }

        private function pad(padding:String, value:String):String
        {
            return padding.slice(0, padding.length - value.toString().length) + value.toString()
        }
    }
}
