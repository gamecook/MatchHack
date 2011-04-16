/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/15/11
 * Time: 9:52 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;

    public class SplashActivity extends BaseActivity
    {

        [Embed(source="../../../../../build/assets/gamecook_presents.png")]

        private var SplashImage : Class;

        public function SplashActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();


            var img : Bitmap = addChild(Bitmap(new SplashImage())) as Bitmap;
			img.x = (fullSizeWidth * .5) - (img.width * .5);
			img.y = (fullSizeHeight * .5) - (img.height * .5);

            startNextActivityTimer(StartActivity, 3);
        }
    }
}
