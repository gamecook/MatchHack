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
    import com.gamecook.matchhack.managers.SingletonManager;
    import com.gamecook.matchhack.managers.SoundManager;
    import com.gamecook.matchhack.states.ActiveGameState;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class LogoActivity extends BaseActivity
    {

        [Embed(source="../../../../../build/assets/logo.png")]
        private var LogoImage:Class;
        protected var logo:Bitmap;
        protected var logoContainer:Sprite;
        protected var soundManager:SoundManager = SingletonManager.getClassReference(SoundManager) as SoundManager;
        protected var activeState:ActiveGameState;

        public function LogoActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            graphics.beginFill(0xff0000, 0);
            graphics.drawRect(0, 0, fullSizeWidth, fullSizeHeight);
            graphics.endFill();

            activeState = new ActiveGameState();
            activeState.load();

            super.onCreate();
        }

        override public function onStart():void
        {
            super.onStart();

            logoContainer = addChild(new Sprite()) as Sprite;

            logo = logoContainer.addChild(Bitmap(new LogoImage())) as Bitmap;
            logo.x = (fullSizeWidth - logo.width) * .5;
            logo.y = 6;

        }

        protected function enableLogo():void
        {
            logoContainer.useHandCursor = true;
            logoContainer.buttonMode = true;
            logoContainer.addEventListener(MouseEvent.CLICK, onHome);
        }

        protected function onHome(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.CLICK, onHome);
            nextActivity(StartActivity);
        }

        override public function onStop():void
        {
            activeState.save();
            super.onStop();
        }
    }
}
