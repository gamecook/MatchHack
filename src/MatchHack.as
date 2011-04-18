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

    [SWF(width="768",height="1024",backgroundColor="#000000",frameRate="60")]
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
            scale = stage.stageHeight / 400;

            tracker = new GATracker(this, key, "AS3", false);

            configureStage();

            super(new MHActivityManager(tracker), SplashActivity, 0, 0, scale)
        }

        private function configureStage():void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            BaseActivity.fullSizeWidth = stage.stageWidth / scale;
            BaseActivity.fullSizeHeight = stage.stageHeight / scale;
        }

        override protected function onFlashResume (event:Event):void
        {
            soundManager.playSounds();
            super.onFlashResume(event);

        }

        override protected function onFlashDeactivate (event:Event):void
        {
            soundManager.pauseSounds();
            super.onFlashDeactivate(event);
        }
    }
}
