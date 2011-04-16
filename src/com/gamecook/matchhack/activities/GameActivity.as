/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/15/11
 * Time: 10:11 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities {
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.PerspectiveProjection;
    import flash.geom.Point;

    import flash.utils.Timer;

    import uk.co.soulwire.display.PaperSprite;

    public class GameActivity extends LogoActivity{

        [Embed(source="../../../../../build/assets/game_board.png")]
        private var GameBoardImage : Class;
        private var flipping:Boolean;
        private var activeTiles:Array = [];
        private var maxActiveTiles:int = 1;

        public function GameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override public function onStart():void
        {
            super.onStart();

            var pp1:PerspectiveProjection=new PerspectiveProjection();
            pp1.fieldOfView=1;
            pp1.projectionCenter=new Point(200,0);

            var gameBackground:Bitmap = addChild(Bitmap(new GameBoardImage())) as Bitmap;
			gameBackground.x = (fullSizeWidth * .5) - (gameBackground.width * .5);
			gameBackground.y = fullSizeHeight - gameBackground.height;

            var tileContainer:Sprite = addChild(new Sprite()) as Sprite;
            tileContainer.x = 73;
            tileContainer.y = 178;

            var total:int = 12;
            var columns:int = 3;
            var i:int;
            var nextX:int = 0;
            var nextY:int = 0;
            var tile:PaperSprite;

            var types:Array = ["type1", "type2", "type3", "type4", "type6", "type7"];
            var typeIndex:int = -1;
            var typeCount:int = 2;

            for (i = 0; i < total; i++)
            {
                if(i % typeCount == 0)
                    typeIndex ++;

                tile = tileContainer.addChild(createTile()) as PaperSprite;
                tile.name = types[typeIndex];
                tile.x = nextX;
                tile.y = nextY;
                tile.pivotX = .5;
                nextX += 64;
                if(nextX % columns == 0)
                {
                    nextX = 0;
                    nextY += 64;
                }


            }

            enableLogo();
        }

        private function createTile():PaperSprite
        {
            // Create Sprite for front
            var front:Sprite = new Sprite();
            front.graphics.beginFill(0x000000,.5);
            front.graphics.drawRect(0, 0, 64, 64);
            front.graphics.endFill();

            // Create Sprite for back
            var back:Sprite = new Sprite();
            back.graphics.beginFill(0x0000ff);
            back.graphics.drawRect(0, 0, 64, 64);
            back.graphics.endFill();

            // Create TwoSidedPlane
            var tempPlane:PaperSprite = new PaperSprite(front, back);
            tempPlane.addEventListener(MouseEvent.CLICK, onClick);
            tempPlane.mouseChildren = false;
            tempPlane.buttonMode = true;
            tempPlane.useHandCursor = true;

            return tempPlane;
        }

        private function onClick(event:MouseEvent):void
        {
            if(!flipping)
            {
                var target:PaperSprite = event.target as PaperSprite;

                if(activeTiles.indexOf(target) != -1)
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

            if(activeTiles.length > maxActiveTiles)
            {

                findMatches();
                trace("Reset Active Tiles");
                resetActiveTiles();
            }
        }

        private function findMatches():void
        {
            var i:int, j:int;
            var total:int = activeTiles.length;
            var currentTile:PaperSprite;
            var testTile:PaperSprite;
            var matches:Array = [];

            for(i=0; i < total; i++)
            {
                currentTile = activeTiles[i];
                for (j =0; j < total; j++)
                {
                    testTile = activeTiles[j];
                    if((currentTile != testTile) && (currentTile.name == testTile.name))
                    {
                        trace("Match Found");
                        matches.push(testTile);
                    }
                }
            }
        }

        private function resetActiveTiles():void
        {
            for each (var tile:PaperSprite in activeTiles) {
                tile.flip();
            }
            activeTiles.length = 0;
        }

        private function onNoMatch():void
        {
        }

        private function onMatch():void
        {



        }

    }
}
