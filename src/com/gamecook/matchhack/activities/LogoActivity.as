/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/15/11
 * Time: 10:12 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class LogoActivity extends BaseActivity{

        [Embed(source="../../../../../build/assets/logo.png")]
        private var LogoImage : Class;
        protected var logo:Bitmap;
        protected var logoContainer:Sprite;

        public function LogoActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            graphics.beginFill(0xff0000,0);
            graphics.drawRect(0,0, fullSizeWidth, fullSizeHeight);
            graphics.endFill();

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
    }
}
