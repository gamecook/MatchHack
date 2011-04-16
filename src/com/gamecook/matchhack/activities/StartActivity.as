/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/15/11
 * Time: 8:44 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class StartActivity extends LogoActivity{



        [Embed(source="../../../../../build/assets/instructions.png")]
        private var Instructions : Class;

        [Embed(source="../../../../../build/assets/new_game_up.png")]
        private var NewGameUp : Class;

        [Embed(source="../../../../../build/assets/new_game_down.png")]
        private var NewGameDown : Class;

        [Embed(source="../../../../../build/assets/credits_up.png")]
        private var CreditsUp : Class;

        [Embed(source="../../../../../build/assets/credits_down.png")]
        private var CreditsDown : Class;

        [Embed(source="../../../../../build/assets/home_splash_image.png")]
        private var HomeSplashImage : Class;

        public function StartActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();



            var instructions : Bitmap = addChild(Bitmap(new Instructions())) as Bitmap;
			instructions.x = (fullSizeWidth - logo.width) * .5;
			instructions.y = logo.x + logo.height + 15;

            var newGameBTN:SimpleButton = addChild(new SimpleButton(new NewGameUp(), new NewGameUp(), new NewGameDown(), new NewGameUp())) as SimpleButton;
            newGameBTN.x = (fullSizeWidth - newGameBTN.width) * .5;
            newGameBTN.y = instructions.y + instructions.height + 10;
            newGameBTN.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var creditsBTN:SimpleButton = addChild(new SimpleButton(new CreditsUp(), new CreditsUp(), new CreditsDown(), new CreditsUp())) as SimpleButton;
            creditsBTN.x = (fullSizeWidth - creditsBTN.width) * .5;
            creditsBTN.y = newGameBTN.y + newGameBTN.height + 4;
            creditsBTN.addEventListener(MouseEvent.MOUSE_UP, onCredits);

            var homeSplash : Bitmap = addChild(Bitmap(new HomeSplashImage())) as Bitmap;
			homeSplash.x = (fullSizeWidth - homeSplash.width) * .5;
			homeSplash.y = fullSizeHeight - homeSplash.height - 15;
        }

        private function onNewGame(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onNewGame);
            nextActivity(GameActivity);
        }

        private function onCredits(event:MouseEvent):void
        {
            event.target.removeEventListener(MouseEvent.MOUSE_UP, onCredits);
            nextActivity(CreditsActivity);
        }
    }
}
