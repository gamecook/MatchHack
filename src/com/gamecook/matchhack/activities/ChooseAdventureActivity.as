/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/30/11
 * Time: 10:14 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities
{
    import com.gamecook.matchhack.enums.GameModes;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.utils.LayoutUtil;

    import flash.display.Bitmap;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    public class ChooseAdventureActivity extends LogoActivity
    {
        [Embed(source="../../../../../build/assets/choose_adventure.png")]
        private var ChooseAdventure:Class;

        [Embed(source="../../../../../build/assets/buttons/classic_button_up.png")]
        private var ClassicUp:Class;

        [Embed(source="../../../../../build/assets/buttons/classic_button_over.png")]
        private var ClassicOver:Class;

        [Embed(source="../../../../../build/assets/buttons/dungeon_crawl_up.png")]
        private var DungeonUp:Class;

        [Embed(source="../../../../../build/assets/buttons/dungeon_crawl_over.png")]
        private var DungeonOver:Class;

        [Embed(source="../../../../../build/assets/buttons/story_mode_up.png")]
        private var StoryUp:Class;

        [Embed(source="../../../../../build/assets/buttons/story_mode_up.png")]
        private var StoryOver:Class;

        public function ChooseAdventureActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            super.onCreate();

            var newGameLabel:Bitmap = addChild(new ChooseAdventure()) as Bitmap;
            LayoutUtil.centerHorizontally(fullSizeWidth, newGameLabel);
            LayoutUtil.stackBelow(logo,  newGameLabel, 20);

            // Adding and setting up difficulty level buttons.

            var classicButton:SimpleButton = addChild(new SimpleButton(new ClassicUp(), new ClassicOver(), new ClassicOver(), new ClassicOver())) as SimpleButton;
            classicButton.name = GameModes.CLASSIC_MODE;
            LayoutUtil.centerHorizontally(fullSizeWidth, classicButton);
            LayoutUtil.stackBelow(newGameLabel, classicButton, 20);
            classicButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var dungeonButton:SimpleButton = addChild(new SimpleButton(new DungeonUp(), new DungeonOver(), new DungeonOver(), new DungeonOver())) as SimpleButton;
            dungeonButton.name = GameModes.DUNGEON_MODE;
            LayoutUtil.centerHorizontally(fullSizeWidth, dungeonButton);
            LayoutUtil.stackBelow(classicButton, dungeonButton, 20);
            dungeonButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var storyButton:SimpleButton = addChild(new SimpleButton(new StoryUp(), new StoryOver(), new StoryOver(), new StoryOver())) as SimpleButton;
            storyButton.name = GameModes.STORY_MODE;
            LayoutUtil.centerHorizontally(fullSizeWidth, storyButton);
            LayoutUtil.stackBelow(dungeonButton, storyButton, 20);
            //storyButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

        }

        /**
         *
         * Sets up the correct game mode and passes it along to the next activity.
         *
         * @param event
         */
        private function onNewGame(event:MouseEvent):void
        {
            nextActivity(NewGameActivity, {gameMode: event.target.name});
        }

        override public function onBack():void
        {
            nextActivity(StartActivity);
        }
    }
}
