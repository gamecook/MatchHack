/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 9/6/11
 * Time: 8:37 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities
{
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.utils.ArrayUtil;
    import com.gamecook.matchhack.views.CharacterView;
    import com.gamecook.matchhack.views.IMenuOptions;
    import com.gamecook.matchhack.views.MenuBar;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;

    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import uk.co.soulwire.display.PaperSprite;


    public class GameActivity2 extends LogoActivity implements IMenuOptions
    {
        private var difficulty:int;
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var player:CharacterView;
        private var monster:CharacterView;
        private var matchIDs:Array;
        private var tileInstances:Array;
        private var currentTile:PaperSprite;

        public function GameActivity2(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {

            super.onCreate();

            // Set the difficulty level from the active state object
            difficulty = activeState.difficulty;

            trace("Difficulty", difficulty);
        }


        override public function onStart():void
        {
            super.onStart();

            var menuBar:MenuBar = addChild(new MenuBar(MenuBar.EXIT_ONLY_MODE, logo.width, this)) as MenuBar;
            menuBar.x = logo.x;
            menuBar.y = logo.y + logo.height - 2;

            createCharacters();
            createTiles();
            createArrows();
            addClickHandler();

            //Just for testing
            displayNextTile();

        }

        private function displayNextTile():void
        {
            currentTile = tileInstances.pop();
            currentTile.x = (fullSizeWidth) * .5;
            currentTile.y = (fullSizeHeight - currentTile.height) * .5;

            addChild(currentTile);
        }

        private function addClickHandler():void
        {
            stage.addEventListener(MouseEvent.CLICK, onClick);
        }

        private function onClick(event:MouseEvent):void
        {
            if(event.localX > fullSizeWidth * .5)
            {
                testMatch(player);
            }
            else
            {
                testMatch(monster);
            }
        }

        private function testMatch(target:CharacterView):void
        {
            if(target.equipmentIDs.indexOf(currentTile.name))
            {
                monster.subtractLife(1);
            }
            else
            {
                player.subtractLife(1);
            }

            currentTile.flip();

            if(tileInstances.length == 0)
                startNextActivityTimer(WinActivity, 2, {characterImage: player.getImage(), droppedEquipment: null});
            else
                displayNextTile();
        }

        private function createArrows():void
        {

        }

        private function createCharacters():void
        {

            //Create Player
             // Create Monster
            var playerModel:MonsterTile = new MonsterTile();
            playerModel.parseObject({name:"player", maxLife: 10 / 2});

            player = addChild(new CharacterView(playerModel)) as CharacterView;
            player.generateRandomEquipment();
            player.x = 25;

             // Create Monster

            var monsterModel:MonsterTile = new MonsterTile();
            monsterModel.parseObject({name:"monster", maxLife: 10 / 2});
            monster = addChild(new CharacterView(monsterModel)) as CharacterView;

            monster.generateRandomEquipment();
            monster.x = fullSizeWidth - (monster.width + 25);
            player.y = monster.y = fullSizeHeight * .5;

            matchIDs = player.equipmentIDs.slice().concat(monster.equipmentIDs.slice());

        }

        private function createTiles():void
        {
            tileInstances = [];
            var total:int = 5;
            var i:int;
            var tileID:String;
            var tile:PaperSprite;

            for (var index:String in matchIDs) {
                for (i = 0; i < total; i ++)
                {
                    tileID = matchIDs[index];
                    tile = createTile(new Bitmap(spriteSheet.getSprite(TileTypes.getTileSprite(tileID))));
                    tile.name = tileID;
                    tileInstances.push(tile);
                }
            }
            tileInstances = ArrayUtil.shuffleArray(tileInstances);

            for each (var tileInstance:PaperSprite in tileInstances)
                trace(tileInstance.name)

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
            var tempPlane:PaperSprite = new PaperSprite(tile, null);

            return tempPlane;
        }

        public function onExit():void
        {
            onBack();
        }

        public function onInventory():void
        {
        }

        public function onPause()
        {
        }
    }
}
