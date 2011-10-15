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
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.utils.DeviceUtil;
    
    import flash.desktop.NativeApplication;
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

        [Embed(source="../../../../../build/assets/buttons/inventory_up.png")]
        private var InventoryUp:Class;

        [Embed(source="../../../../../build/assets/buttons/inventory_over.png")]
        private var InventoryOver:Class;

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

            soundManager.mute = activeState.mute;
        }

        override public function onStart():void
        {
            super.onStart();

            var welcomeImage:Bitmap = addChild(new WelcomeImage()) as Bitmap;
            welcomeImage.x = (fullSizeWidth - welcomeImage.width) * .5;
            welcomeImage.y = logo.y + logo.height + 10;

            var newGameBTN:SimpleButton = addChild(new SimpleButton(new NewGameUp(), new NewGameOver(), new NewGameOver(), new NewGameUp())) as SimpleButton;
            newGameBTN.x = (fullSizeWidth - newGameBTN.width) * .5;
            newGameBTN.y = welcomeImage.y + welcomeImage.height + 10;
            newGameBTN.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var creditsBTN:SimpleButton = addChild(new SimpleButton(new ContinueUp(), new ContinueOver(), new ContinueOver(), new ContinueUp())) as SimpleButton;

            // Check to see if an activeGame exists
            if (activeState.activeGame)
            {
                creditsBTN.upState = new ContinueUp();
                creditsBTN.overState = new ContinueOver();
                creditsBTN.downState = new ContinueOver();
                creditsBTN.addEventListener(MouseEvent.MOUSE_UP, onContinue);
            }
            else
            {
                // If no game is active, disable the button.
                creditsBTN.enabled = false;
                creditsBTN.upState = new ContinueDisabled();
            }


            // Layout credits button.
            creditsBTN.x = (fullSizeWidth - creditsBTN.width) * .5;
            creditsBTN.y = newGameBTN.y + newGameBTN.height + 4;

            var inventoryBTN:SimpleButton = addChild(new SimpleButton(new InventoryUp(), new InventoryOver(), new InventoryOver(), new InventoryUp())) as SimpleButton;
            inventoryBTN.x = (fullSizeWidth - inventoryBTN.width) * .5;
            inventoryBTN.y = creditsBTN.y + creditsBTN.height + 4;
            inventoryBTN.addEventListener(MouseEvent.MOUSE_UP, onInventory);


            soundBTN = addChild(new SimpleButton(new SoundOn(), null, null, new SoundOn())) as SimpleButton;

            soundBTN.x = (fullSizeWidth - soundBTN.width) * .5;
            soundBTN.y = inventoryBTN.y + inventoryBTN.height + 4;
            soundBTN.addEventListener(MouseEvent.MOUSE_UP, onSoundToggle);
            updateMuteButtonState();

            var homeSplash:Bitmap = addChild(Bitmap(new HomeSplashImage())) as Bitmap;
            homeSplash.x = (fullSizeWidth - homeSplash.width) * .5;
            homeSplash.y = fullSizeHeight - homeSplash.height - 15;

            startNextActivityTimer(CreditsActivity, 5);

            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function onInventory(event:MouseEvent):void
        {
            nextActivity(InventoryActivity);
        }

        /**
         *
         * Toggles the Mute value in the SoundManager
         *
         * @param event
         */
        private function onSoundToggle(event:MouseEvent = null):void
        {

            soundManager.mute = !soundManager.mute;

            updateMuteButtonState();

            soundManager.play(MHSoundClasses.WallHit);
        }

        /**
         *
         * Updates the visual state of the Mute Button.
         *
         */
        private function updateMuteButtonState():void
        {
            if (!soundManager.mute)
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

            if (activeState.mute != soundManager.mute)
            {
                activeState.mute = soundManager.mute;
                saveState();
            }
        }

        /**
         *
         * This allows the player to delay the feature timer whenever a click is detected on the background.
         *
         * @param event
         */
        private function onClick(event:MouseEvent):void
        {
            nextScreenCounter = 0;
        }

        /**
         *
         * Activates the NewGameActivity
         *
         * @param event
         */
        private function onNewGame(event:MouseEvent):void
        {
            soundManager.play(MHSoundClasses.WallHit);
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onNewGame);
            nextActivity(NewGameActivity);
        }

        /**
         *
         * Activates the GameActivity when the Continue button is active.
         *
         * @param event
         */
        private function onContinue(event:MouseEvent):void
        {
            soundManager.play(MHSoundClasses.WallHit);
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onContinue);
            nextActivity(GameActivity);
        }


        override public function onBack():void
        {
            if(DeviceUtil.os == DeviceUtil.ANDROID)
				NativeApplication.nativeApplication.exit();
			else
				super.onBack();
        }
    }
}
