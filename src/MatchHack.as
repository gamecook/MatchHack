package  
{
    import com.gamecook.matchhack.activities.SplashActivity;
    import com.gamecook.matchhack.activities.StartActivity;
    import com.jessefreeman.factivity.AbstractApplication;

    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.ActivityManager;

    import flash.display.StageScaleMode;
	import flash.display.StageAlign;

	/**
	 * @author jessefreeman
	 */

    [SWF(width="480",height="800",backgroundColor="#000000",frameRate="60")]
	public class MatchHack extends AbstractApplication
	{


		public function MatchHack()
		{
			configureStage();
			super(new ActivityManager(), SplashActivity, 0, 0, 2)
		}

		private function configureStage() : void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
            BaseActivity.fullSizeWidth = stage.stageWidth * .5;
            BaseActivity.fullSizeHeight = stage.stageHeight * .5;
		}
	}
}
