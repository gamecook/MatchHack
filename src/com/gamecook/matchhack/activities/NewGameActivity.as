/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.gamecook.matchhack.activities
{
    import com.gamecook.matchhack.enums.DifficultyLevels;
    import com.jessefreeman.factivity.activities.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;

    /**
     *
     * This handles creating a new game, setting the difficulty level and resetting the ActiveGameState object
     *
     */
    public class NewGameActivity extends LogoActivity
    {
        [Embed(source="../../../../../build/assets/new_game_label.png")]
        private var NewGame:Class;

        [Embed(source="../../../../../build/assets/buttons/easy_up.png")]
        private var EasyUp:Class;

        [Embed(source="../../../../../build/assets/buttons/easy_over.png")]
        private var EasyOver:Class;

        [Embed(source="../../../../../build/assets/buttons/medium_up.png")]
        private var MediumUp:Class;

        [Embed(source="../../../../../build/assets/buttons/medium_over.png")]
        private var MediumOver:Class;

        [Embed(source="../../../../../build/assets/buttons/hard_up.png")]
        private var HardUp:Class;

        [Embed(source="../../../../../build/assets/buttons/hard_over.png")]
        private var HardOver:Class;

        [Embed(source="../../../../../build/assets/difficulty_levels.png")]
        private var DifficultyImage:Class;

        public function NewGameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            var newGameLabel:Bitmap = addChild(new NewGame()) as Bitmap;
            newGameLabel.x = (fullSizeWidth - newGameLabel.width) * .5;
            newGameLabel.y = logo.y + logo.height + 20;

            // Adding and setting up difficulty level buttons.

            var easyButton:SimpleButton = addChild(new SimpleButton(new EasyUp(), new EasyOver(), new EasyOver(), new EasyUp())) as SimpleButton;
            easyButton.name = DifficultyLevels.EASY;
            easyButton.x = (fullSizeWidth - easyButton.width) * .5;
            easyButton.y = newGameLabel.y + newGameLabel.height + 20;
            easyButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var mediumButton:SimpleButton = addChild(new SimpleButton(new MediumUp(), new MediumOver(), new MediumOver(), new MediumUp())) as SimpleButton;
            mediumButton.name = DifficultyLevels.MEDIUM;
            mediumButton.x = (fullSizeWidth - mediumButton.width) * .5;
            mediumButton.y = easyButton.y + easyButton.height + 5;
            mediumButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            var hardButton:SimpleButton = addChild(new SimpleButton(new HardUp(), new HardOver(), new HardOver(), new HardUp())) as SimpleButton;
            hardButton.name = DifficultyLevels.HARD;
            hardButton.x = (fullSizeWidth - hardButton.width) * .5;
            hardButton.y = mediumButton.y + mediumButton.height + 5;
            hardButton.addEventListener(MouseEvent.MOUSE_UP, onNewGame);

            // Sets up teh difficulty description image
            var difficultyImage:Bitmap = addChild(new DifficultyImage()) as Bitmap;
            difficultyImage.x = (fullSizeWidth - difficultyImage.width) * .5;
            difficultyImage.y = hardButton.y + hardButton.height + 30;

            enableLogo();
        }

        /**
         *
         * Sets up the correct game mode and passes it along to the next activity.
         *
         * @param event
         */
        private function onNewGame(event:MouseEvent):void
        {
            var difficulty:int;

            // Set up difficulty mode based on currently click on target's name.
            switch (event.target.name)
            {
                case DifficultyLevels.EASY:
                    difficulty = 1;
                    break;
                case DifficultyLevels.MEDIUM:
                    difficulty = 2;
                    break;
                case DifficultyLevels.HARD:
                    difficulty = 3;
                    break;
            }

            // Clear the active state for a new game
            activeState.reset();

            // Reset active state values
            activeState.difficulty = difficulty;
            activeState.playerLevel = 1;
            activeState.activeGame = true;

            // Go to next activity, GameActivity
            nextActivity(GameActivity);
        }

        override public function onBack():void
        {
            nextActivity(StartActivity);
        }
    }
}
