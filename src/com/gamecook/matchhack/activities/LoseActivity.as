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
    import com.jessefreeman.factivity.threads.effects.CountUpTextEffect;
    import com.gamecook.matchhack.factories.TextFieldFactory;
    import com.jessefreeman.factivity.activities.IActivityManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    /**
     *
     * Activity displayed when the player dies.
     *
     */
    public class LoseActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/you_lose.png")]
        private var YouLoseImage:Class;

        [Embed(source="../../../../../build/assets/click_to_continue.png")]
        private var ContinueImage:Class;

        private var bonusTF:TextField;
        private var scoreTF:TextField;

        public function LoseActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            activeState.increaseTotalLosses();
            // Add you lose bitmap.
            var youLose:Bitmap = addChild(Bitmap(new YouLoseImage())) as Bitmap;
            youLose.x = (fullSizeWidth * .5) - (youLose.width * .5);
            youLose.y = logo.y + logo.height + 30;

            var character:Bitmap = addChild(data.characterImage) as Bitmap;
            character.x = (fullSizeWidth - character.width) * .5;
            character.y = youLose.y + youLose.height + 15;

            bonusTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, formatBonusText(), 160)) as TextField;
            bonusTF.x = (fullSizeWidth - bonusTF.width) * .5;
            bonusTF.y = character.y + character.height + 10;

            scoreTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, TextFieldFactory.SCORE_LABEL + TextFieldFactory.padScore(), 160)) as TextField;
            scoreTF.x = (fullSizeWidth - scoreTF.width) * .5;
            scoreTF.y = bonusTF.y + bonusTF.height + 10;

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

            var continueLabel:Bitmap = addChild(Bitmap(new ContinueImage())) as Bitmap;
            continueLabel.x = (fullSizeWidth - continueLabel.width) * .5;
            continueLabel.y = fullSizeHeight - (continueLabel.height + 10);

            var countUpEffect:CountUpTextEffect = new CountUpTextEffect(scoreTF);
            countUpEffect.newValue(activeState.score, scoreTF.text);
            addThread(countUpEffect);

            // Clear out the rest of the activeState values since the game is over.
            activeState.reset();
        }

        private function formatBonusText():String
        {
            var message:String = "GAME STATS\n" +
                    "Difficulty: " + DifficultyLevels.getLabel(activeState.difficulty) + "\n" +
                    "Level: " + activeState.playerLevel + "\n" +
                    "Total Turns: " + activeState.levelTurns + "\n" +
                    "Best Bonus: x" + activeState.bestBonus;

            return message;
        }

        private function onClick(event:MouseEvent):void
        {
            // Kill all sounds
            soundManager.destroySounds(true);

            // Return to start activity
            nextActivity(StartActivity);
        }
    }
}
