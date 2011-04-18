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
    import com.gamecook.matchhack.utils.ArrayUtil;
    import com.gamecook.matchhack.views.CharacterView;
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import uk.co.soulwire.display.PaperSprite;

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

        public function GameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

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

            }

            var difficulty:int = 2;// 1, 2 or 3
            player = tileContainer.addChild(new CharacterView("player", total / difficulty)) as CharacterView;
            monster = tileContainer.addChild(new CharacterView("monster", total / 2)) as CharacterView;


            layoutTiles();

            enableLogo();


        }

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

        private function createTile(tile:Bitmap):PaperSprite
        {
            // Create Sprite for front
            var front:Sprite = new Sprite();
            front.graphics.beginFill(0x000000, .5);
            front.graphics.drawRect(0, 0, 64, 64);
            front.graphics.endFill();

            // Create TwoSidedPlane
            var tempPlane:PaperSprite = new PaperSprite(front, tile);
            tempPlane.addEventListener(MouseEvent.CLICK, onClick);
            tempPlane.mouseChildren = false;
            tempPlane.buttonMode = true;
            tempPlane.useHandCursor = true;

            return tempPlane;
        }

        private function onClick(event:MouseEvent):void
        {
            if (!flipping)
            {
                var target:PaperSprite = event.target as PaperSprite;

                if ((activeTiles.indexOf(target) != -1) || player.isDead())
                    return;

                activeTiles.push(target);
                target.addEventListener(Event.COMPLETE, onFlipComplete);
                target.flip();
                flipping = true;
            }

        }

        private function onFlipComplete(event:Event):void
        {
            var target:PaperSprite = event.target as PaperSprite;
            target.removeEventListener(Event.COMPLETE, onFlipComplete);
            trace("Target.isFrontFacing", target.isFrontFacing);
            flipping = false;

            if (activeTiles.length > maxActiveTiles)
            {

                findMatches();
                resetActiveTiles();
                //validateWin();
            }

            trace("Player", player.getLife(), "Monster", monster.getLife());
        }

        private function validateWin():void
        {
            var success:Boolean = testTiles();

            if (success)
                startNextActivityTimer(WinActivity, 2);
        }

        private function testTiles():Boolean
        {
            for each(var tile:PaperSprite in tileInstances)
            {
                if (tile.visible == true)
                    return false;

            }

            return true;

        }

        private function findMatches():void
        {
            var i:int, j:int;
            var total:int = activeTiles.length;
            var currentTile:PaperSprite;
            var testTile:PaperSprite;

            var match:Boolean;

            for (i = 0; i < total; i++)
            {
                currentTile = activeTiles[i];
                for (j = 0; j < total; j++)
                {
                    testTile = activeTiles[j];
                    if ((currentTile != testTile) && (currentTile.name == testTile.name))
                    {
                        currentTile.visible = false;
                        testTile.visible = false;
                        match = true;

                    }
                }
            }

            if (match)
                onMatch();
            else
                onNoMatch();
        }

        private function resetActiveTiles():void
        {
            for each (var tile:PaperSprite in activeTiles)
            {
                tile.flip();
            }
            activeTiles.length = 0;
        }

        private function onNoMatch():void
        {
            player.subtractLife(1);
            if (player.isDead())
                onPlayerDead();
        }

        private function onMatch():void
        {
            monster.subtractLife(1);
            if (monster.isDead())
                onMonsterDead();
        }

        private function onPlayerDead():void
        {
            player.flip();
            startNextActivityTimer(LoseActivity, 2);
        }

        private function onMonsterDead():void
        {
            monster.flip();
            startNextActivityTimer(WinActivity, 2);
        }

    }
}
