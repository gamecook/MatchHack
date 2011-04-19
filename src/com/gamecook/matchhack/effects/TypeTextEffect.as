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

/**
 * Created by IntelliJ IDEA.
 * User: Jesse Freeman
 * Date: 2/27/11
 * Time: 12:07 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.effects
{
    import com.jessefreeman.factivity.threads.GreenThread;

    import flash.text.TextField;

    public class TypeTextEffect extends GreenThread
    {
        private var target:TextField;
        private var message:String;
        private var speed:int;
        private var counter:int = 0;

        public function TypeTextEffect(target:TextField, updateCallback:Function = null, finishCallback:Function = null)
        {
            this.target = target;
            super(updateCallback, finishCallback);
        }

        public function newMessage(message:String, speed:int = 1):void
        {
            this.speed = speed;
            this.message = message;
        }


        override public function start():void
        {
            target.text = "";
            counter = 0;
            super.start();
        }

        override public function run(elapsed:Number = 0):void
        {
            super.run(elapsed);
            counter += speed;
            if (counter > message.length)
                counter = message.length;

            target.text = message.substr(0, counter);


            if (counter == message.length)
                finish();
        }
    }
}
