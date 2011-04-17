/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/17/11
 * Time: 12:07 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;

    public class LoadingActivity extends LogoActivity{

        [Embed(source="../../../../../build/assets/instructions.png")]
        private var InstructionsImage : Class;

        [Embed(source="../../../../../build/assets/loading.png")]
        private var LoadingImage : Class;

        private var textCounter:int = 0;
        private var textDelay:int = 300;
        private var loading:Bitmap;

        public function LoadingActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            var instructions : Bitmap = addChild(new InstructionsImage()) as Bitmap;
			instructions.x = (fullSizeWidth - instructions.width) * .5;
			instructions.y = logo.x + logo.height + 15;

            loading = addChild(new LoadingImage()) as Bitmap
            loading.x = (fullSizeWidth - loading.width) * .5;
            loading.y = instructions.y + instructions.height + 30;

            startNextActivityTimer(GameActivity, 3);
        }


        override public function update(elapsed:Number = 0):void
        {
            super.update(elapsed);

            textCounter += elapsed;


            if (textCounter >= textDelay) {
                textCounter = 0;
                loading.visible = !loading.visible;
            }
        }
    }
}
