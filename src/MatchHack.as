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

package
{
    import com.gamecook.matchhack.activities.SplashActivity;
    import com.gamecook.matchhack.managers.MHActivityManager;
    import com.gamecook.matchhack.managers.SingletonManager;
    import com.gamecook.matchhack.managers.SoundManager;
    import com.google.analytics.GATracker;
    import com.jessefreeman.factivity.AbstractApplication;
    import com.jessefreeman.factivity.activities.BaseActivity;

    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;

    [SWF(width="480",height="800",backgroundColor="#000000",frameRate="60")]
    public class MatchHack extends AbstractApplication
    {

        protected var soundManager:SoundManager = SingletonManager.getClassReference(SoundManager) as SoundManager;
        private var tracker:GATracker;
        private var scale:Number = 1;

        /*
            You will need to create a class called analytics.as with the following in it:

            private var key:String = "UA-xxxxxxxx-x";

         */
        include "analytics.as";

        public function MatchHack()
        {
            // Automatically figures out the scale based on stage's height. Used to scale up on each device.
            scale = stage.stageHeight / 400;

            // Google Analytics Tracker
            tracker = new GATracker(this, key, "AS3", false);

            // Configures the stage
            configureStage();

            // Passes up a custom ActivityManager to super along with the start activity and scale.
            super(new MHActivityManager(tracker), SplashActivity, 0, 0, scale)
        }

        private function configureStage():void
        {
            // Setup stage align and scale mode.
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            // Set up the screen size for BaseActivity
            BaseActivity.fullSizeWidth = stage.stageWidth / scale;
            BaseActivity.fullSizeHeight = stage.stageHeight / scale;
        }

        /**
         *
         * Called when the game get's focus. All sounds should resume.
         *
         * @param event
         */
        override protected function onFlashResume (event:Event):void
        {
            soundManager.playSounds();
            super.onFlashResume(event);

        }

        /**
         *
         * Called when the game loses focus. All sounds are killed.
         *
         * @param event
         */
        override protected function onFlashDeactivate (event:Event):void
        {
            soundManager.pauseSounds();
            super.onFlashDeactivate(event);
        }
    }
}
