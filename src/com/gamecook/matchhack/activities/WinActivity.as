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
    import com.gamecook.matchhack.sounds.MHSoundClasses;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;

    /**
     *
     * Shown when the player wins and is ready to move onto the next level.
     *
     */
    public class WinActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/you_win.png")]
        private var YouWinImage:Class;

        public function WinActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            //TODO need to update player stats and save out state.
            var youWin:Bitmap = addChild(Bitmap(new YouWinImage())) as Bitmap;
            youWin.x = (fullSizeWidth * .5) - (youWin.width * .5);
            youWin.y = fullSizeHeight - youWin.height - 50;

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

        }

        private function onClick(event:MouseEvent):void
        {
            soundManager.destroySounds(true);
            soundManager.play(MHSoundClasses.WalkStairsSound);
            nextActivity(GameActivity);
        }
    }
}
