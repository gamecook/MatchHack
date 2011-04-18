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

package com.gamecook.matchhack.activities
{
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;

    public class LoadingActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/instructions.png")]
        private var InstructionsImage:Class;

        [Embed(source="../../../../../build/assets/loading.png")]
        private var LoadingImage:Class;

        private var textCounter:int = 0;
        private var textDelay:int = 300;
        private var loading:Bitmap;

        public function LoadingActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            var instructions:Bitmap = addChild(new InstructionsImage()) as Bitmap;
            instructions.x = (fullSizeWidth - instructions.width) * .5;
            instructions.y = logo.x + logo.height + 15;

            loading = addChild(new LoadingImage()) as Bitmap
            loading.x = (fullSizeWidth - loading.width) * .5;
            loading.y = instructions.y + instructions.height + 30;

            startNextActivityTimer(GameActivity, 3);
        }


        override public function update(elapsed:Number = 0):void
        {
            super.update(elapsed);

            textCounter += elapsed;


            if (textCounter >= textDelay)
            {
                textCounter = 0;
                loading.visible = !loading.visible;
            }
        }
    }
}
