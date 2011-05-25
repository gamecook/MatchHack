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
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.matchhack.factories.SpriteSheetFactory;
    import com.gamecook.matchhack.sounds.MHSoundClasses;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;
    import flash.events.MouseEvent;

    /**
     *
     * This class acts as a simple way to show the use the instructions. There is actually no loading going on here,
     * there is just a delay to go to the next activity. This activity can also be used to display hints, tips and ads.
     *
     */
    public class LoadingActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/instructions.png")]
        private var InstructionsImage:Class;

        [Embed(source="../../../../../build/assets/click_to_continue.png")]
        private var ContinueImage:Class;

        public function LoadingActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override public function onStart():void
        {
            super.onStart();

            // Add instructions bitmap and lay it out
            var instructions:Bitmap = addChild(new InstructionsImage()) as Bitmap;
            instructions.x = (fullSizeWidth - instructions.width) * .5;
            instructions.y = logo.x + logo.height + 15;

            var continueLabel:Bitmap = addChild(Bitmap(new ContinueImage())) as Bitmap;
            continueLabel.x = (fullSizeWidth - continueLabel.width) * .5;
            continueLabel.y = fullSizeHeight - (continueLabel.height + 10);

            // Add event listener to activity for click.
            addEventListener(MouseEvent.CLICK, onClick);

            var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
            spriteSheet.clear();

            SpriteSheetFactory.parseSpriteSheet(spriteSheet);

        }

        private function onClick(event:MouseEvent):void
        {

            // Play walking sound for player entering the new game
            soundManager.play(MHSoundClasses.WalkStairsSound);
            // Return to start activity
            nextActivity(GameActivity);
        }

        /**
         * We are loading, there is nothing to go back to.
         */
        override public function onBack():void
        {

        }
    }
}
