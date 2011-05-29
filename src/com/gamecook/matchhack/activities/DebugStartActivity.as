/**
 * Created by IntelliJ IDEA.
 * User: jfreeman
 * Date: 3/22/11
 * Time: 4:44 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities
{
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.matchhack.enums.PlayerClassTemplates;
    import com.gamecook.matchhack.factories.NewGameFactory;
    import com.gamecook.matchhack.factories.SpriteSheetFactory;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;


    public class DebugStartActivity extends LogoActivity
    {

        public function DebugStartActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            // this allows you to jump right into a newly generated game,
            // use this area to configure the ActiveGameState
            NewGameFactory.createCoffeeBreakGame(PlayerClassTemplates.getPlayerClasses(),
                    ["Reveal"],
                    ["ModeA"],
                    [13],
                    [true],
                    [true]);

            SpriteSheetFactory.parseSpriteSheet(SingletonManager.getClassReference(SpriteSheet) as SpriteSheet);

            nextActivity(DungeonActivity);
        }
    }
}
