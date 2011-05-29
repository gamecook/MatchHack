/**
 * Created by IntelliJ IDEA.
 * User: Jesse Freeman
 * Date: 2/19/11
 * Time: 9:58 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities
{
    import com.gamecook.frogue.combat.ICombatant;
    import com.gamecook.frogue.equipment.IEquipable;
    import com.gamecook.frogue.helpers.MovementHelper;
    import com.gamecook.frogue.io.Controls;
    import com.gamecook.frogue.io.IControl;
    import com.gamecook.frogue.managers.TileInstanceManager;
    import com.gamecook.frogue.maps.MapAnalytics;
    import com.gamecook.frogue.maps.MapPopulater;
    import com.gamecook.frogue.maps.RandomMap;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.templates.Template;
    import com.gamecook.frogue.templates.TemplateApplicator;
    import com.gamecook.frogue.templates.TemplateCollection;
    import com.gamecook.frogue.templates.TemplateProperties;
    import com.gamecook.frogue.tiles.EquipmentTile;
    import com.gamecook.frogue.tiles.PlayerTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.tilecrusader.factories.TCTileFactory;
    import com.gamecook.tilecrusader.iterators.TreasureIterator;
    import com.gamecook.tilecrusader.maps.TCMapSelection;
    import com.gamecook.tilecrusader.renderer.MQMapBitmapRenderer;
    import com.gamecook.tilecrusader.renderer.PreviewMapRenderer;
    import com.gamecook.tilecrusader.sounds.TCSoundClasses;
    import com.gamecook.tilecrusader.threads.effects.EaseScrollBehavior;
    import com.jessefreeman.factivity.activities.ActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.utils.TimeMethodExecutionUtil;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;

    public class DungeonActivity extends LogoActivity implements IControl
    {


        public var map:RandomMap;
        private var renderer:MQMapBitmapRenderer;
        private var renderWidth:int;
        private var renderHeight:int;
        private var darknessWidth:int;
        private var darknessHeight:int;
        private var controls:Controls;
        private var movementHelper:MovementHelper;
        private var invalid:Boolean = true;
        private var player:PlayerTile;
        private var tileInstanceManager:TileInstanceManager;
        private var treasureIterator:TreasureIterator;
        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var mapBitmap:Bitmap;
        private var mapSelection:TCMapSelection;

        private var display:Sprite;
        private var overlayLayer:Sprite;
        private var status:String = "";
        private static const TILE_SIZE:int = 32;
        private var scale:int = 1;
        private var tileWidth:int;
        private var tileHeight:int;
        private var viewPortWidth:int = 0;
        private var viewPortHeight:int = 0;
        private const MESSAGE_HEIGHT:int = 40;
        private var cashPool:int = 0;
        private var cashRange:int = 10;
        private var treasurePool:Array;

        private var pollKeyPressCounter:int = 0;
        private var keyPressDelay:int = 0;
        private var _nextMove:Point;
        private var templateApplicator:TemplateApplicator;
        private var monsterTemplates:TemplateCollection;
        private var exploredTiles:Number;
        private var analytics:MapAnalytics;

        private var visibility:int;
        private var currentPoint:Point;
        private var currentuID:String;
        private var mouseDown:Boolean;
        private var previewMapShape:Shape;
        private var previewMapRenderer:PreviewMapRenderer;
        private var scrollThread:EaseScrollBehavior;
        //private var characterSheet:CharacterSheetView;
        private var monsters:Array = [];
        private var chests:Array = [];

        public function DungeonActivity(activityManager:ActivityManager, data:* = null)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {

            super.onCreate();

            createMap();
            //saveState();

        }

        private function createMap():void
        {
            //Create new Random Map
            map = new RandomMap();

            // Test to see if the current active state already has map
            if (activeState.map)
            {
                // Get tiles from game state's map object
                map.setTiles(activeState.map.tiles);
            }
            else
            {
                // If there were no tiles, generate a new map
                TimeMethodExecutionUtil.execute("generateMap", map.generateMap, activeState.size, 2);

                //activeState.startMessage = "You enter the dark dungeon.";

                generateMonsters();
                generateTreasure();


                //TODO Create start position and exit based on game mode.

                var populateMapHelper:MapPopulater = new MapPopulater(map);
                populateMapHelper.populateMap.apply(this, monsters);
                populateMapHelper.populateMap.apply(this, chests);

                var exitPosition:Point = populateMapHelper.getRandomEmptyPoint();
                map.swapTile(exitPosition, "E");

                activeState.startPositionPoint = populateMapHelper.getRandomEmptyPoint();

                activeState.map = map.toObject();

                // Swap out some open tiles
                var total:int = populateMapHelper.getOpenSpaces() * .3;
                var i:int;
                for (i = 0; i < total; i++)
                {
                    map.swapTile(populateMapHelper.getRandomEmptyPoint(), TileTypes.getRandomOpenTile());
                }
            }

            trace("Map Size", map.width, map.height, "was generated");

        }

        private function generateTreasure():void
        {

            // Config stuff
            var emptyTreasureChests:Boolean = true;
            var trapTreasureChests:Boolean = false;

            var totalChests:int = 10;//Math.floor((Math.random() * monsters.length) + .1);
            var treasurePool:Array = [];

            // These are the types of treasure in the game
            var treasureTypes:Array = ["$","P"];

            if (emptyTreasureChests)
                treasureTypes.push("K");

            if (emptyTreasureChests)
                treasureTypes.push(" ");

            var treasureTypesTotal:int = treasureTypes.length;

            // Calculate the amount of treasure based on the total monsters in the game
            var treasurePoolTotal:int = Math.floor((Math.random() * monsters.length) + .1);

            var i:int;
            //var treasureChestTotal:int = treasurePoolTotal *
            for (i = 0; i < treasurePoolTotal; i ++)
            {

                treasurePool.push(treasureTypes[Math.floor((Math.random() * treasureTypesTotal))]);
                if (i < totalChests)
                {
                    chests.push("T");
                }
            }

            activeState.treasurePool = treasurePool;
            trace("Treasure Pool", treasurePool.length, "in", chests.length, "values", treasurePool.toString());

        }

        private function generateMonsters():void
        {
            var monsterTypes:Array = ["1","2","3","4","5","6","7","8"];
            var monsterPercentage:Array = [.3,.2,.1, .1, .05, .02, .02, .01];
            var totalMonsterPercent:Number = .3;
            var i:int = 0;
            var j:int = 0;
            var total:int = monsterTypes.length;
            var monsterValues:Number;
            var monsterType:int;
            var totalTiles:int = Math.ceil(RandomMap(map).getOpenTiles().length * totalMonsterPercent);

            for (i = 0; i < total; i++)
            {
                //TODO need to look into why the values are sometimes larger then what they really are.
                monsterValues = Math.floor(monsterPercentage[i] * totalTiles);
                monsterType = monsterTypes[i];
                //trace("MonsterType", monsterType, "monsterValues", monsterValues);
                for (j = 0; j < monsterValues; j++)
                {

                    monsters.push(monsterType);
                }
            }

            //monsters.push("9");

        }


        private function configureMonsterTemplates():void
        {
            templateApplicator = new TemplateApplicator();
            monsterTemplates = new TemplateCollection();

            monsterTemplates.addTemplate("1", new Template("Regular", [TemplateProperties.LIFE, TemplateProperties.ATTACK, TemplateProperties.DEFENSE, TemplateProperties.LIFE]), 30);
            monsterTemplates.addTemplate("2", new Template("Tank", [TemplateProperties.LIFE, TemplateProperties.DEFENSE, TemplateProperties.LIFE, TemplateProperties.ATT_DEF]), 4);
            monsterTemplates.addTemplate("3", new Template("Chaos", [TemplateProperties.RANDOM]), 1);
            monsterTemplates.addTemplate("4", new Template("Brute", [TemplateProperties.ATTACK, TemplateProperties.ATTACK, TemplateProperties.DEFENSE, TemplateProperties.LIFE]), 3);
            monsterTemplates.addTemplate("5", new Template("Attack Specialist", [TemplateProperties.ATTACK, TemplateProperties.ATTACK, TemplateProperties.LIFE, TemplateProperties.DEFENSE]), 2);
            monsterTemplates.addTemplate("6", new Template("Defense Specialist", [TemplateProperties.DEFENSE, TemplateProperties.DEFENSE, TemplateProperties.LIFE, TemplateProperties.ATTACK]), 2);
            monsterTemplates.addTemplate("7", new Template("Life Specialist", [TemplateProperties.LIFE, TemplateProperties.LIFE, TemplateProperties.LIFE, TemplateProperties.ATT_DEF]), 3);
            monsterTemplates.addTemplate("8", new Template("Chaos Specialist", [TemplateProperties.RANDOM, TemplateProperties.LIFE, TemplateProperties.RANDOM, TemplateProperties.ATT_DEF]), 1);
        }

        override public function onStart():void
        {
            display = addChild(new Sprite()) as Sprite;
            overlayLayer = addChild(new Sprite()) as Sprite;

            //map = data.mapInstance;
            /*analytics = new MapAnalytics(map);

            TimeMethodExecutionUtil.execute("updateMapAnalytics", analytics.update);*/
            //var remainingMonsters:int = TimeMethodExecutionUtil.execute("remainingMonsters", analytics.getTotal, "1", "2", "3", "4", "5", "6", "7", "8", "9");
            //trace("Monsters in MapAnalytics", remainingMonsters);


            //gameMode = activeState.gameType;
            treasurePool = activeState.treasurePool;
            cashPool = 100;//activeState.cashPool;
            cashRange = 10;//activeState.cashRange;

            // Configure Tile, Render and Darkness size
            tileWidth = tileHeight = TILE_SIZE * scale;
            viewPortWidth = (fullSizeWidth);// - SIDEBAR_WIDTH);
            viewPortHeight = (fullSizeHeight - tileHeight);


            renderWidth = Math.floor(viewPortWidth / tileWidth);
            renderHeight = Math.floor((viewPortHeight - tileHeight) / tileHeight);

            darknessWidth = 5;
            darknessHeight = 4;
            visibility = 4;//activeState.player.visibility;

            movementHelper = new MovementHelper(map);

            configureMonsterTemplates();


            tileInstanceManager = new TileInstanceManager(new TCTileFactory(monsterTemplates, templateApplicator, activeState.player.characterPoints, 0));

            mapSelection = new TCMapSelection(map, renderWidth, renderHeight, visibility, tileInstanceManager);
            mapSelection.fullLineOfSight(true);

            if (activeState.mapSelection)
            {
                mapSelection.parseObject(activeState.mapSelection);
            }

            mapBitmap = new Bitmap(new BitmapData(renderWidth * tileWidth, renderHeight * tileHeight, false, 0x000000));
            mapBitmap.scaleX = mapBitmap.scaleY = scale;
            display.addChild(mapBitmap);


            renderer = new MQMapBitmapRenderer(mapBitmap.bitmapData, spriteSheet, tileInstanceManager);

            //TODO this should be moved into the MapLoadingActivity
            if (activeState.tileInstanceManager)
                tileInstanceManager.parseObject(activeState.tileInstanceManager);

            player = tileInstanceManager.getInstance("@", "@", activeState.player) as PlayerTile;

            //TODO need to make this it's own class
            /*statusLabel = new Label(this, 5, 2, "");
             statusLabel.textField.width = viewPortWidth - 5;
             statusLabel.textField.autoSize = "none";
             statusLabel.textField.height = MESSAGE_HEIGHT;
             statusLabel.textField.multiline = true;
             statusLabel.textField.wordWrap = true;
             statusLabel.x = 5;
             statusLabel.y = 2;
             overlayLayer.addChild(statusLabel);*/

            //TODO need to add start message
            //addStatusMessage(activeState.startMessage);

            configureGame();

            //TODO May need to slow this down for mobile
            keyPressDelay = .25 * MILLISECONDS;

            /*virtualKeys = new VirtualKeysView(this);
             addChild(virtualKeys);
             virtualKeys.x = fullSizeWidth - (virtualKeys.width + 10);
             virtualKeys.y = fullSizeHeight - (virtualKeys.height + 10);*/
            //virtualKeys.scaleX = virtualKeys.scaleY = .5;

            /*if (DeviceUtil.os != DeviceUtil.IOS)
             {
             quakeEffect = new Quake(display);
             textEffect = new TypeTextEffect(statusLabel.textField, onTextEffectUpdate);
             }*/

            scrollThread = new EaseScrollBehavior(renderer, onScrollUpdate, onScrollComplete);

            //TODO this isn't working look into it.
            /*if(activeGameState.startMessage)
             PopUpManager.showOverlay(new AlertPopUpWindow(activeGameState.startMessage));*/


            previewMapShape = new Shape();

            previewMapShape.visible;
            addChild(previewMapShape);

            previewMapRenderer = new PreviewMapRenderer(previewMapShape.graphics, new Rectangle(0, 0, 3, 3));

            previewMapRenderer.renderMap(map);

            //previewMapShape.y = fullSizeHeight - previewMapShape.height;

            /*characterSheet = addChild(new CharacterSheetView(player)) as CharacterSheetView;
            characterSheet.x = fullSizeWidth - characterSheet.width;*/

            super.onStart();
            //This needs to be a compiler argument for debug
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

            controls = new Controls(this);

            //soundManager.play(TCSoundClasses.WalkStairsSound);

            // Layout displays
            previewMapShape.x = fullSizeWidth - previewMapShape.width + 10;
            previewMapShape.y = logo.y + logo.height;

            mapBitmap.x = (fullSizeWidth - mapBitmap.width) * .5;
            mapBitmap.y = previewMapShape.y + previewMapShape.height + 5;

            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            addEventListener(MouseEvent.CLICK, onMouseClick);

            enableLogo();
        }

        private function onScrollComplete():void
        {
            //trace("Scroll Complete");
            renderer.scrollX = 0;
            renderer.scrollY = 0;
        }

        private function onScrollUpdate():void
        {
            //trace("Scroll Update", renderer.scrollX, scrollThread.targetX);
            invalidate();
        }

        private function onKeyDown(event:KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                /*case Keyboard.L:
                    cycleThroughLighting();
                    break;*/
                case Keyboard.P:
                    player.setLife(player.getMaxLife());
                    break;
            }

            invalidate();
        }

        private function onTextEffectUpdate():void
        {
            soundManager.play(TCSoundClasses.TypeSound);
        }

        private function configureGame():void
        {
            //mapSelection.clear();

            //tileInstanceManager.clear();

            treasureIterator = new TreasureIterator(treasurePool);

            movementHelper.startPosition(activeState.startPositionPoint);
        }

        //TODO need to clean up movement so it only happens once per second
        public function up():void
        {
            nextMove(MovementHelper.UP);
        }

        public function down():void
        {
            nextMove(MovementHelper.DOWN);
        }

        public function right():void
        {
            nextMove(MovementHelper.RIGHT);
        }

        public function left():void
        {
            nextMove(MovementHelper.LEFT);
        }

        private function nextMove(value:Point):void
        {
            if (!scrollThread.isRunning())
            {
                if (value.y == 1)
                {
                    scrollThread.targetX = 0;
                    scrollThread.targetY = -32;
                }
                else if (value.x == 1)
                {
                    scrollThread.targetX = -32;
                    scrollThread.targetY = 0;
                }
                else if (value.y == -1)
                {
                    scrollThread.targetX = 0;
                    scrollThread.targetY = 32;
                }
                else
                {

                    scrollThread.targetX = 32;
                    scrollThread.targetY = 0;
                }

                _nextMove = value;
            }
        }

        public function move(value:Point):void
        {

            if (player.isDead)
                return;

            var tmpPoint:Point = movementHelper.previewMove(value.x, value.y);

            if (tmpPoint != null)
            {
                var tile:String = map.getTileType(tmpPoint);

                switch (TileTypes.getTileType(tile))
                {
                    case TileTypes.IMPASSABLE:
                        //TODO need to make sure we don't call render here
                        soundManager.play(TCSoundClasses.WallHit);
                        return;
                    case TileTypes.MONSTER:
                    case TileTypes.BOSS:
                        map.swapTile(tmpPoint, "X2");
                        var uID:String = map.getTileID(tmpPoint.y, tmpPoint.x).toString();

                        var tmpTile:ICombatant = tileInstanceManager.getInstance(uID, tile) as ICombatant;

                        if (tmpTile is ICombatant)
                        {
                            currentPoint = tmpPoint;
                            currentuID = uID;
                            fight(tmpTile);
                        }
                        break;
                    case TileTypes.TREASURE:
                        openTreasure(tmpPoint);
                        break;
                    case TileTypes.EXIT:
                        movePlayer(value);
                        //TODO gameover
                        //TODO play heroic theme here?
                        trace("Level Done");
                        break;
                    default:
                        movePlayer(value);
                        break;
                }
                invalidate();
            }
            /*if (status.length > 0)
             {
             if (textEffect)
             {
             textEffect.newMessage(status, 2);
             addThread(textEffect);
             status = "";
             }
             else
             {
             statusLabel.text = status;
             }
             }
             else
             {
             statusLabel.text = status;
             }*/
        }

        private function equip(player:PlayerTile, tmpTile:EquipmentTile, uID:String, tilePoint:Point, nextMovePoint:Point):void
        {
            //TODO prompt user to equip

            var droppedEquipment:IEquipable = player.equip(tmpTile.getEquipment());

            addStatusMessage(player.getName() + " has equipped " + tmpTile.getEquipment().description + ".\nNew stats: Attack " + player.getAttackRolls() + " | Defense " + player.getDefenceRolls());
            //TODO make sure the player is actually picking up the item.


            var newTile:String = TileTypes.getEmptyTile();

            // Drop weapon
            if (droppedEquipment)
            {
                newTile = droppedEquipment.tileID;

                var equipmentTile:EquipmentTile = new EquipmentTile();
                equipmentTile.parseObject({equipment:droppedEquipment.toObject()});

                tileInstanceManager.registerInstance(mapSelection.getTileID(movementHelper.playerPosition.y, movementHelper.playerPosition.x).toString(), equipmentTile);
            }
            else
            {
                tileInstanceManager.removeInstance(uID);
            }

            swapTileOnMap(tilePoint, newTile);

            movePlayer(nextMovePoint);


        }

        private function onCompleteLevel(success:Boolean):void
        {
            // Level has been finished, remove map sepcific info from state
            activeState.clearMapData();
            activeState.player = player.toObject();
            // for state to save to update the player.
            activeState.save();

            //TODO where do we gone when the map is completed?
            trace("Map was completed")
            //startNextActivityTimer(FinishMapActivity, 1, {success:success});
        }

        private function onLeaveMap():void
        {
            onCompleteLevel(false);
        }

        public function addStatusMessage(value:String, clear:Boolean = true):void
        {
            if (clear)
                status = "";
            status += value;
        }

        private function fight(monster:ICombatant):void
        {
            trace("Fight Monster");
            //TODO need to go into combat activity
            nextActivity(CombatActivity);
        }

        private function openTreasure(tmpPoint:Point):void
        {


            addStatusMessage(player.getName() + " has opened a treasure chest.");

            var treasure:String = treasureIterator.hasNext() ? treasureIterator.getNext() : " ";
            if (treasure == "K")
            {
                addStatusMessage("\nA trap was sprung dealing 1 point of damage.", false);
                player.subtractLife(1);
                /*if (quakeEffect)
                 addThread(quakeEffect);*/
                treasure = " ";
            }

            swapTileOnMap(tmpPoint, treasure);
        }

        protected function swapTileOnMap(point:Point, tile:String):void
        {
            map.swapTile(point, tile);
        }

        private function movePlayer(value:Point):void
        {
            movementHelper.move(value.x, value.y);
            player.addStep();

            //TODO enable to get animation working
            /*if(!scrollThread.isRunning())
             addThread(scrollThread);*/
        }

        protected function invalidate():void
        {
            invalid = true;
        }

        override public function update(elapsed:Number = 0):void
        {
            pollKeyPressCounter += elapsed;

            if (pollKeyPressCounter >= keyPressDelay)
            {
                pollKeyPressCounter = 0;

                if (mouseDown)
                {
                    onUpdateMousePosition();
                }

                if (_nextMove)
                {
                    move(_nextMove);
                    _nextMove = null
                }
            }

            super.update(elapsed);

            exploredTiles = mapSelection.getVisitedTiles() / map.getOpenTiles().length;

        }

        override protected function render():void
        {
            super.render();

            if (invalid)
            {
                //characterSheet.update();
                mapSelection.setCenter(movementHelper.playerPosition);
                renderer.renderMap(mapSelection);

                var pos:Point = movementHelper.playerPosition;

                var x:int = pos.x - mapSelection.getOffsetX();
                var y:int = pos.y - mapSelection.getOffsetY();

                var playerSprite:String = TileTypes.getTileSprite("@");

                //Add custom sprite overlay (equipment)
                if (player.getSpriteID() != "")
                    playerSprite = playerSprite.concat("," + player.getSpriteID()); // Removed "," from here since now it's done in the tile instance

                //Add life sprite
                if (player.getLife() < player.getMaxLife())
                    playerSprite = playerSprite.concat(",life" + (Math.round(player.getLife() / player.getMaxLife() * 100).toString()));


                if (Math.round(player.getLife() / player.getMaxLife() * 100) < 30)
                {
                    var matrix:Array = new Array();
                    matrix = matrix.concat([1,0,0,0,0]);// red
                    matrix = matrix.concat([0,0,0,0,0]);// green
                    matrix = matrix.concat([0,0,0,0,0]);// blue
                    matrix = matrix.concat([0,0,0,1,0]);// alpha
                    var my_filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);

                    var rect:Rectangle = new Rectangle(0, 0, mapBitmap.width, mapBitmap.height);

                    mapBitmap.bitmapData.applyFilter(mapBitmap.bitmapData.clone(), rect, new Point(0, 0), my_filter);
                }

                //Draw player
                renderer.renderPlayer(x, y, playerSprite);


                previewMapRenderer.renderPlayer(mapSelection.getOffsetX() + x, mapSelection.getOffsetY() + y, playerSprite);

                invalid = false;

                trace("$Render");
            }


        }


        private function onMouseClick(event:MouseEvent):void
        {
            onUpdateMousePosition();
        }

        private function onMouseDown(event:MouseEvent):void
        {
            mouseDown = true;
        }

        private function onMouseUp(event:MouseEvent):void
        {
            mouseDown = false;
        }

        private function onUpdateMousePosition():void
        {

            var localPoint:Point = new Point(Math.floor((mouseX - mapBitmap.x) / TILE_SIZE), Math.floor((mouseY - mapBitmap.y) / TILE_SIZE));
            var tileID:int = mapSelection.getTileID(localPoint.x, localPoint.y);

            //trace("Update Mouse Position", mouseX, mouseY, localPoint);


            var playerPoint:Point = mapSelection.getCenter().clone();
            playerPoint.x -= mapSelection.getOffsetX();
            playerPoint.y -= mapSelection.getOffsetY();


            var distanceX:Number = localPoint.x - playerPoint.x;
            var distanceY:Number = -1 * (localPoint.y - playerPoint.y);

            var angle:Number = Math.atan2(distanceY, distanceX); // radians
            angle = Math.round(angle / Math.PI * 180); // degrees

            var dir:String;

            var directionX:int = 0;
            var directionY:int = 0;

            if (angle >= -135 && angle <= -45)
            {
                directionY = 1;

            }
            else if (angle >= -45 && angle <= 45)
            {
                directionX = 1;

            }
            else if (angle >= 45 && angle <= 135)
            {
                directionY = -1;

            }
            else
            {
                directionX = -1;

            }

            nextMove(new Point(directionX, directionY));

        }

        override public function loadState():void
        {
            activeState.load();
        }

        override public function saveState():void
        {
            activeState.player = player.toObject();
            activeState.tileInstanceManager = tileInstanceManager.toObject();
            activeState.mapSelection = mapSelection.toObject();
            activeState.startPositionPoint = movementHelper.playerPosition;
            activeState.map = map.toObject();
            activeState.save();
        }

        override public function onStop():void
        {
            saveState();
            super.onStop();
        }

    }
}
