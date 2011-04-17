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

    public class WinActivity extends LogoActivity{

        [Embed(source="../../../../../build/assets/you_win.png")]
        private var YouWinImage : Class;

        public function WinActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            var youWin:Bitmap = addChild(Bitmap(new YouWinImage())) as Bitmap;
			youWin.x = (fullSizeWidth * .5) - (youWin.width * .5);
			youWin.y = fullSizeHeight - youWin.height - 50;

            graphics.beginFill(0xff0000,0);
            graphics.drawRect(0,0, fullSizeWidth, fullSizeHeight);
            graphics.endFill();

            addEventListener(MouseEvent.CLICK, onClick);

        }

        private function onClick(event:MouseEvent):void
        {
            nextActivity(StartActivity);
        }
    }
}
