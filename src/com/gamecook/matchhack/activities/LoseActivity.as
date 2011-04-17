/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/16/11
 * Time: 9:09 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.events.MouseEvent;

    public class LoseActivity extends LogoActivity{

        [Embed(source="../../../../../build/assets/you_lose.png")]
        private var YouLoseImage : Class;

        public function LoseActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            var youLose:Bitmap = addChild(Bitmap(new YouLoseImage())) as Bitmap;
			youLose.x = (fullSizeWidth * .5) - (youLose.width * .5);
			youLose.y = fullSizeHeight - youLose.height - 50;

            addEventListener(MouseEvent.CLICK, onClick);

        }

        private function onClick(event:MouseEvent):void
        {
            nextActivity(StartActivity);
        }
    }
}
