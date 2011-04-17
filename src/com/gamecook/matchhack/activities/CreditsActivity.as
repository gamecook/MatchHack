/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/15/11
 * Time: 10:11 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;

    public class CreditsActivity extends LogoActivity{

        [Embed(source="../../../../../build/assets/credits.png")]
        private var CreditsImage : Class;

        public function CreditsActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            var credits:Bitmap = addChild(Bitmap(new CreditsImage())) as Bitmap;
			credits.x = (fullSizeWidth - credits.width) * .5;
			credits.y = (fullSizeHeight - credits.height) - 5;

            enableLogo();

            startNextActivityTimer(StartActivity, 5);

            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function onClick(event:MouseEvent):void
        {
            nextActivity(StartActivity);
        }
    }
}
