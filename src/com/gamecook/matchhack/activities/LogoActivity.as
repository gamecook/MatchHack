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
    import com.gamecook.matchhack.states.ActiveGameState;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.activities.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    /**
     *
     * This is the base Activity all of the game Activities should extend from. It has logic for displaying the LOGO
     * and also enabling the logo to be clickable to go back to the home screen.
     *
     */
    public class LogoActivity extends BaseActivity
    {

        [Embed(source="../../../../../build/assets/logo.png")]
        private var LogoImage:Class;
        protected var logo:Bitmap;
        protected var logoContainer:Sprite;
        protected var activeState:ActiveGameState;

        public function LogoActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            // This fills in the Activity's background with a solid color so there is something to click on.
            graphics.beginFill(0xff0000, 0);
            graphics.drawRect(0, 0, fullSizeWidth, fullSizeHeight);
            graphics.endFill();

            // Sets up the ActiveGameState object
            activeState = new ActiveGameState();
            activeState.load();

            super.onCreate();
        }

        override public function onStart():void
        {
            super.onStart();

            // Creates a container for the logo
            logoContainer = addChild(new Sprite()) as Sprite;

            // Attaches the logo
            logo = logoContainer.addChild(Bitmap(new LogoImage())) as Bitmap;
            logo.x = (fullSizeWidth - logo.width) * .5;
            logo.y = 6;

        }

        /**
         *
         * Call this to turn the Logo into a Back Button.
         *
         */
        protected function enableLogo():void
        {
            logoContainer.useHandCursor = true;
            logoContainer.buttonMode = true;
            logoContainer.addEventListener(MouseEvent.CLICK, onHome);
        }

        /**
         *
         * Called when the logo is clicked and returns to StartActivity.
         *
         * @param event
         */
        protected function onHome(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.CLICK, onHome);
            nextActivity(StartActivity);
        }

        /**
         *
         * Forces the ActiveState object to save when an activity stops.
         *
         */
        override public function onStop():void
        {
            activeState.save();
            super.onStop();
        }
    }
}
