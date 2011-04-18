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
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public class StartActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/buttons/new_game_up.png")]
        private var NewGameUp:Class;

        [Embed(source="../../../../../build/assets/buttons/new_game_over.png")]
        private var NewGameOver:Class;

        [Embed(source="../../../../../build/assets/buttons/continue_up.png")]
        private var ContinueUp:Class;

        [Embed(source="../../../../../build/assets/buttons/continue_over.png")]
        private var ContinueOver:Class;

        [Embed(source="../../../../../build/assets/buttons/continue_dissabled.png")]
        private var ContinueDisabled:Class;

        [Embed(source="../../../../../build/assets/buttons/sound_on.png")]
        private var SoundOn:Class;

        [Embed(source="../../../../../build/assets/buttons/sound_off.png")]
        private var SoundOff:Class;

        [Embed(source="../../../../../build/assets/home_splash_image.png")]
        private var HomeSplashImage:Class;

        [Embed(source="../../../../../build/assets/welcome_text.png")]
        private var WelcomeImage:Class;

        private var soundBTN:SimpleButton;

        public function StartActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {
            soundManager.playMusic(MHSoundClasses.DungeonLooper);

            super.onCreate();
        }

        override public function onStart():void
        {
            super.onStart();

            var welcomeImage:Bitmap = addChild(new WelcomeImage()) as Bitmap;
            welcomeImage.x = (fullSizeWidth - welcomeImage.width) * .5;
            welcomeImage.y = logo.y + logo.height + 10;

            var newGameBTN:SimpleButton = addChild(new SimpleButton(new NewGameUp(), new NewGameOver(), new NewGameOver(), new NewGameUp())) as SimpleButton;
            newGameBTN.x = (fullSizeWidth - newGameBTN.width) * .5;
            newGameBTN.y = welcomeImage.y + welcomeImage.height + 20;
            newGameBTN.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var creditsBTN:SimpleButton = addChild(new SimpleButton(new ContinueUp(), new ContinueOver(), new ContinueOver(), new ContinueUp())) as SimpleButton;
            //Disable button
            creditsBTN.enabled = false;
            creditsBTN.upState = new ContinueDisabled();

            // TODO need to connect up continue
            //creditsBTN.addEventListener(MouseEvent.MOUSE_UP, onCredits);

            creditsBTN.x = (fullSizeWidth - creditsBTN.width) * .5;
            creditsBTN.y = newGameBTN.y + newGameBTN.height + 4;


            soundBTN = addChild(new SimpleButton(new SoundOn(), null, null, new SoundOn())) as SimpleButton;

            soundBTN.x = (fullSizeWidth - soundBTN.width) * .5;
            soundBTN.y = creditsBTN.y + creditsBTN.height + 4;
            soundBTN.addEventListener(MouseEvent.MOUSE_UP, onSoundToggle);
            onSoundToggle();

            var homeSplash:Bitmap = addChild(Bitmap(new HomeSplashImage())) as Bitmap;
            homeSplash.x = (fullSizeWidth - homeSplash.width) * .5;
            homeSplash.y = fullSizeHeight - homeSplash.height - 15;

            startNextActivityTimer(CreditsActivity, 5);

            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function onSoundToggle(event:MouseEvent = null):void
        {

            soundManager.mute = !soundManager.mute;

            if(!soundManager.mute)
            {
                soundBTN.upState = new SoundOn();
                soundBTN.overState = new SoundOn();
                soundBTN.downState = new SoundOn();
            }
            else
            {
                soundBTN.upState = new SoundOff();
                soundBTN.overState = new SoundOff();
                soundBTN.downState = new SoundOff();
            }

            soundManager.play(MHSoundClasses.WallHit);
        }

        private function onClick(event:MouseEvent):void
        {
            nextScreenCounter = 0;
        }

        private function onNewGame(event:MouseEvent):void
        {
            soundManager.play(MHSoundClasses.WallHit);
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onNewGame);
            nextActivity(NewGameActivity);
        }

        private function onCredits(event:MouseEvent):void
        {
            soundManager.play(MHSoundClasses.WallHit);
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onCredits);
            nextActivity(CreditsActivity);
        }
    }
}
