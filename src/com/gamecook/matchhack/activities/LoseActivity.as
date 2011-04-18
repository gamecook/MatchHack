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
    import flash.events.MouseEvent;

    /**
     *
     * Activity displayed when the player dies.
     *
     */
    public class LoseActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/you_lose.png")]
        private var YouLoseImage:Class;

        public function LoseActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            // Add you lose bitmap.
            var youLose:Bitmap = addChild(Bitmap(new YouLoseImage())) as Bitmap;
            youLose.x = (fullSizeWidth * .5) - (youLose.width * .5);
            youLose.y = fullSizeHeight - youLose.height - 50;

            // Add click handler
            addEventListener(MouseEvent.CLICK, onClick);

        }

        private function onClick(event:MouseEvent):void
        {
            // Kill all sounds
            soundManager.destroySounds(true);

            // Return to start activity
            nextActivity(StartActivity);
        }
    }
}
