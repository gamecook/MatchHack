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
    import com.gamecook.matchhack.factories.SpriteFactory;
    import com.gamecook.matchhack.sounds.MHSoundClasses;
    import com.gamecook.matchhack.utils.ArrayUtil;
    import com.gamecook.matchhack.views.CharacterView;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import uk.co.soulwire.display.PaperSprite;

    /**
     *
     * This class represents the core logic for the game.
     *
     */
    public class GameActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/game_board.png")]
        private var GameBoardImage:Class;
        private var flipping:Boolean;
        private var activeTiles:Array = [];
        private var maxActiveTiles:int = 1;
        private var tileContainer:Sprite;
        private var tileInstances:Array = [];
        private var player:CharacterView;
        private var monster:CharacterView;
        private var difficulty:int;

        public function GameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {
            // Have the soundManager play the background theme song
            soundManager.playMusic(MHSoundClasses.DungeonLooper);

            super.onCreate();

            // Set the difficulty level from the active state object
            difficulty = activeState.difficulty;
        }

        override public function onStart():void
        {
            super.onStart();

            trace("Player Level", activeState.playerLevel,"\nTurns", activeState.turns);

            var gameBackground:Bitmap = addChild(Bitmap(new GameBoardImage())) as Bitmap;
            gameBackground.x = (fullSizeWidth * .5) - (gameBackground.width * .5);
            gameBackground.y = fullSizeHeight - gameBackground.height;

            tileContainer = addChild(new Sprite()) as Sprite;
            tileContainer.x = gameBackground.x + 55;
            tileContainer.y = gameBackground.y + 50;

            var total:int = 10;
            var i:int;
            var tile:PaperSprite;

            var sprites:Array = SpriteFactory.createSprites(6);

            var typeIndex:int = -1;
            var typeCount:int = 2;
            var tileBitmap:Bitmap;



            //TODO need to inject player and monster into this array
            for (i = 0; i < total; i++)
            {
                if (i % typeCount == 0)
                    typeIndex ++;

                tileBitmap = new sprites[typeIndex]() as Bitmap;

                tile = tileContainer.addChild(createTile(tileBitmap)) as PaperSprite;
                tileInstances.push(tile);
                tile.name = "type" + typeIndex;
                if(difficulty == 1)
                    tile.flip();

            }


            player = tileContainer.addChild(new CharacterView("player", total / difficulty)) as CharacterView;
            monster = tileContainer.addChild(new CharacterView("monster", total / 2)) as CharacterView;


            layoutTiles();

            enableLogo();


        }

        /**
         *
         * Goes through the tileInstance array and lays them out in a grid.
         *
         */
        private function layoutTiles():void
        {
            tileInstances = ArrayUtil.shuffleArray(tileInstances);

            tileInstances.splice(4, 0, player);
            tileInstances.splice(7, 0, monster);

            var total:int = tileInstances.length;
            var columns:int = 3;
            var i:int;
            var nextX:int = 0;
            var nextY:int = 0;
            var tile:DisplayObject;

            for (i = 0; i < total; i++)
            {
                tile = tileInstances[i];
                tile.x = nextX;
                tile.y = nextY;

                nextX += 64;
                if (nextX % columns == 0)
                {
                    nextX = 0;
                    nextY += 64;
                }

            }
        }

        /**
         *
         * Creates a new tile with a bitmap on it's back.
         *
         * @param tile - BitmapImage to use for back of tile.
         * @return Instance of the created PaperSprite tile.
         *
         */
        private function createTile(tile:Bitmap):PaperSprite
        {
            // Create Sprite for front
            var front:Sprite = new Sprite();
            front.graphics.beginFill(0x000000, .5);
            front.graphics.drawRect(0, 0, 64, 64);
            front.graphics.endFill();

            // Create TwoSidedPlane
            var tempPlane:PaperSprite = new PaperSprite(front, tile);

            // Make PaperSprite act as a button
            tempPlane.addEventListener(MouseEvent.CLICK, onClick);
            tempPlane.mouseChildren = false;
            tempPlane.buttonMode = true;
            tempPlane.useHandCursor = true;

            return tempPlane;
        }

        /**
         *
         * Handle click event from Tile.
         *
         * @param event
         */
        private function onClick(event:MouseEvent):void
        {
            // Test to see if a tile is flipping
            if (!flipping)
            {
                // Play flip sound
                soundManager.play(MHSoundClasses.WallHit);

                // Get instance of the currently selected PaperSprite
                var target:PaperSprite = event.target as PaperSprite;

                // If this tile is already active exit the method
                if ((activeTiles.indexOf(target) != -1) || player.isDead())
                    return;

                // push the tile into the active tile array
                activeTiles.push(target);

                // Check if the difficulty is 1, we need to do handle this different for the easy level.
                if(difficulty > 1)
                {

                    // We are about to flip the tile. Add a complete event listener so we know when it's done.
                    target.addEventListener(Event.COMPLETE, onFlipComplete);

                    // Flip the tile
                    target.flip();

                    // Set the flipping flag.
                    flipping = true;
                }
                else
                {
                    // If difficulty was set to 1 (easy) there is no flip so manually call endTurn.
                    endTurn();
                }

            }

        }

        /**
         *
         * Called when a tile's Flip is completed.
         *
         * @param event
         *
         */
        private function onFlipComplete(event:Event):void
        {
            // Get the tile that recently flipped
            var target:PaperSprite = event.target as PaperSprite;

            // Remove the event listener
            target.removeEventListener(Event.COMPLETE, onFlipComplete);

            // Set the flipping flag to false
            flipping = false;

            // End the turn.
            endTurn();
        }

        /**
         *
         * This validates if we have reached the total number of active tiles. If so we need to check for matches and
         * handle any related game logic.
         *
         */
        private function endTurn():void
        {

            // See if we have active the maximum active tiles allowed.
            if (activeTiles.length > maxActiveTiles)
            {
                // Validate any matches
                findMatches();

                // Reset any tiles that do not match
                resetActiveTiles();

                // Increment our turns counter in the activeState object
                activeState.turns += 1;
            }

        }

        /**
         *
         * This method goes through all of the Active tiles and tries to identify any matches.
         *
         */
        private function findMatches():void
        {
            var i:int, j:int;
            var total:int = activeTiles.length;
            var currentTile:PaperSprite;
            var testTile:PaperSprite;

            var match:Boolean;

            // Loop through active tiles and compare each item to the rest of the tiles in the array.
            for (i = 0; i < total; i++)
            {
                // save an instance of the current tile to test with
                currentTile = activeTiles[i];

                // Reloop through all the items starting back at the beginning
                for (j = 0; j < total; j++)
                {
                    // select the item to test against
                    testTile = activeTiles[j];

                    // Make sure we aren't testing the same item
                    if ((currentTile != testTile) && (currentTile.name == testTile.name))
                    {
                        // A match has been found so make sure the current tile and test tile are set to invisible.
                        currentTile.visible = false;
                        testTile.visible = false;

                        // Flag that a match has been found.
                        match = true;

                    }
                }
            }

            // Validate match
            if (match)
                onMatch();
            else
                onNoMatch();
        }

        /**
         *
         * Loops through any active tiles and flips them. This only calls flip for any difficulty level higher then 1 (easy)
         *
         */
        private function resetActiveTiles():void
        {
            // Loop through all tiles
            for each (var tile:PaperSprite in activeTiles)
            {
                // Make sure the difficulty is higher then easy
                if(difficulty > 1)
                    tile.flip();
            }

            // Clear the activeTiles array when we are done.
            activeTiles.length = 0;
        }

        /**
         *
         * Called when no match is found.
         *
         */
        private function onNoMatch():void
        {
            // Take away 1 HP from the player
            player.subtractLife(1);

            // Play attack sound
            soundManager.play(MHSoundClasses.EnemyAttack);

            // Test to see if the player is dead
            if (player.isDead())
                onPlayerDead();
        }

        /**
         *
         * Called when a match is found.
         *
         */
        private function onMatch():void
        {
            // Take away 1 HP from the monster
            monster.subtractLife(1);

            // Play attack sound
            soundManager.play(MHSoundClasses.PotionSound);

            // Test to see if the monster is dead
            if (monster.isDead())
                onMonsterDead();
        }

        /**
         *
         * Called when the player is dead.
         *
         */
        private function onPlayerDead():void
        {
            // Flip over the player's tile to show the blood
            player.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play death sound
            soundManager.play(MHSoundClasses.DeathTheme);

            // Clear the activeState object since the game is over
            activeState.clear();

            // Show the game over activity after 2 seconds
            startNextActivityTimer(LoseActivity, 2);
        }

        /**
         *
         * Called when the monster is dead.
         *
         */
        private function onMonsterDead():void
        {
            // Flip over the monster's tile to show the blood.
            monster.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play win sound
            soundManager.play(MHSoundClasses.WinBattle);

            // Increment the player by 1 level
            activeState.playerLevel += 1;

            // Show the game over activity after 2 seconds
            startNextActivityTimer(WinActivity, 2);
        }

    }
}
