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
    import com.gamecook.frogue.helpers.MovementHelper;
    import com.gamecook.frogue.io.Controls;
    import com.gamecook.frogue.io.IControl;
    import com.gamecook.frogue.managers.TileInstanceManager;
    import com.gamecook.frogue.maps.MapAnalytics;
    import com.gamecook.frogue.maps.RandomMap;
    import com.gamecook.frogue.renderer.PreviewMapRenderer;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.templates.Template;
    import com.gamecook.frogue.templates.TemplateApplicator;
    import com.gamecook.frogue.templates.TemplateCollection;
    import com.gamecook.frogue.templates.TemplateProperties;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.PlayerTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.enums.DifficultyLevels;
    import com.gamecook.matchhack.factories.DungeonFactory;
    import com.gamecook.matchhack.factories.TCTileFactory;
    import com.gamecook.matchhack.maps.TCMapSelection;
    import com.gamecook.matchhack.renderer.MQMapBitmapRenderer;
    import com.gamecook.matchhack.views.IMenuOptions;
    import com.gamecook.matchhack.views.MenuBar;
    import com.gamecook.matchhack.views.StatusBarView;
    import com.jessefreeman.factivity.activities.ActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.threads.effects.TypeTextEffect;
    import com.jessefreeman.factivity.utils.ArrayUtil;
    import com.jessefreeman.factivity.utils.DeviceUtil;

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

    public class DungeonActivity extends LogoActivity implements IControl, IMenuOptions
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
        //private var treasureIterator:TreasureIterator;
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

        private var statusBar:StatusBarView;
        private var difficulty:int;
        private var textEffect:TypeTextEffect;
        private var pause:Boolean;

        public function DungeonActivity(activityManager:ActivityManager, data:* = null)
        {
            super(activityManager, data);
        }

        override protected function onCreate():void
        {
            super.onCreate();

            difficulty = activeState.difficulty;
            map = DungeonFactory.createMap(activeState);

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
            super.onStart();

            display = addChild(new Sprite()) as Sprite;
            overlayLayer = addChild(new Sprite()) as Sprite;

            var menuBar:MenuBar = addChild(new MenuBar(MenuBar.EXIT_ONLY_MODE, logo.width, this)) as MenuBar;
            menuBar.x = logo.x;
            menuBar.y = logo.y + logo.height - 2;

            //map = data.mapInstance;
            /*analytics = new MapAnalytics(map);

            TimeMethodExecutionUtil.execute("updateMapAnalytics", analytics.update);*/
            //var remainingMonsters:int = TimeMethodExecutionUtil.execute("remainingMonsters", analytics.getTotal, "1", "2", "3", "4", "5", "6", "7", "8", "9");
            //trace("Monsters in MapAnalytics", remainingMonsters);
            statusBar = addChild(new StatusBarView()) as StatusBarView;
            statusBar.x = (fullSizeWidth - statusBar.width) * .5;
            statusBar.y = menuBar.y + 8;

            //gameMode = activeState.gameType;
            treasurePool = ["P","$"," "];//activeState.treasurePool;
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


            //TODO maybe one day this will work on iOS?
            if (DeviceUtil.os != DeviceUtil.IOS)
            {
                textEffect = new TypeTextEffect(statusBar.message);
            }

            enableLogo();

            update();
        }

        private function updateStatusBar():void
        {
            statusBar.setScore(activeState.score);
            statusBar.setLevel(activeState.playerLevel, "<span class='lightGray'>-"+DifficultyLevels.getLabel(difficulty).substr(0,1).toUpperCase())+"</span>";
            statusBar.setTurns(activeState.levelTurns);
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

        private function configureGame():void
        {
            //mapSelection.clear();

            //tileInstanceManager.clear();

            //treasureIterator = new TreasureIterator(treasurePool);

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
            _nextMove = value;
        }

        public function move(value:Point):void
        {

            if (player.isDead || pause)
                return;

            var tmpPoint:Point = movementHelper.previewMove(value.x, value.y);

            if (tmpPoint != null)
            {
                var tile:String = map.getTileType(tmpPoint);

                switch (TileTypes.getTileType(tile))
                {
                    case TileTypes.IMPASSABLE:
                        //TODO need to make sure we don't call render here
                        //soundManager.play(MatchHack.WallHit);
                        return;
                    case TileTypes.MONSTER:
                    case TileTypes.BOSS:
                        pause = true;
                        //TODO this needs to be moved into the map creation logic so you don't see it happen.
                        map.swapTile(tmpPoint, "X2");
                        var uID:String = map.getTileID(tmpPoint.y, tmpPoint.x).toString();

                        var tmpTile:MonsterTile = tileInstanceManager.getInstance(uID, tile) as MonsterTile;

                        if (tmpTile is ICombatant)
                        {
                            currentPoint = tmpPoint;
                            currentuID = uID;
                            activeState.monster = tmpTile.toObject();
                            updateStatusMessage("You have found a monster.\nPrepare for combat!!");
                            startNextActivityTimer(CombatActivity,2);
                        }
                        break;
                    case TileTypes.TREASURE:
                        openTreasure(tmpPoint);
                        break;
                    case TileTypes.EXIT:
                        movePlayer(value);
                        //TODO gameover
                        //TODO play heroic theme here?
                        onLeaveMap();
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

        private function onCompleteLevel(success:Boolean):void
        {
            // Level has been finished, remove map sepcific info from state
            activeState.clearMapData();
            activeState.player = player.toObject();
            // for state to save to update the player.
            activeState.save();
            activeState.playerLevel ++;
            soundManager.destroySounds(true);

            //TODO This should go to a end of level stat screen
            startNextActivityTimer(DungeonActivity, 1, {success:success});
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

        private function openTreasure(tmpPoint:Point):void
        {


            addStatusMessage(player.getName() + " has opened a treasure chest.");

            var treasure:String = ArrayUtil.pickRandomArrayElement(treasurePool);//treasureIterator.hasNext() ? treasureIterator.getNext() : " ";
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

        public function updateStatusMessage(value:String):void
        {
            value = "<span class='orange'>"+value+"</span>";

            if (value.length > 0)
            {
                if (textEffect)
                {
                    textEffect.newMessage(value, 2);
                    addThread(textEffect);
                    value = "";
                }
                else
                {
                    statusBar.message.text = value;
                }
            }
            else
            {
                statusBar.message.text = value;
            }
        }
    }
}
