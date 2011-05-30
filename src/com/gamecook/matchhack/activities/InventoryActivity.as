/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/16/11
 * Time: 11:03 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.activities
{
    import com.flashartofwar.BitmapScroller;
    import com.flashartofwar.behaviors.EaseScrollBehavior;
    import com.flashartofwar.ui.Slider;
    import com.gamecook.frogue.enum.SlotsEnum;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.factories.SpriteFactory;
    import com.gamecook.matchhack.factories.SpriteSheetFactory;
    import com.gamecook.matchhack.factories.TextFieldFactory;
    import com.gamecook.matchhack.utils.BitmapUtil;
    import com.gamecook.matchhack.views.IMenuOptions;
    import com.gamecook.matchhack.views.MenuBar;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class InventoryActivity extends LogoActivity implements IMenuOptions
    {

        [Embed(source="../../../../../build/assets/inventory_text.png")]
        private var InventoryText:Class;

        private var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var bitmapScroller:BitmapScroller;
        private var slider:Slider;
        private var easeScrollBehavior:EaseScrollBehavior;
        private var scrollerContainer:Sprite;
        private var instancesRects:Array = [];
        private var textFieldStamp:TextField;
        public var tileSize:int = 64;
        private var bitmapData:BitmapData;
        private var coinContainer:Bitmap;
        private var playerSprite:Bitmap;
        private var offset:int = 190;
        private var unlockedPercent:Number = 0;
        private var statsTF:TextField;

        public function InventoryActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            super.onCreate();


            var inventoryText:Bitmap = addChild(new InventoryText()) as Bitmap;
            inventoryText.x = (fullSizeWidth - inventoryText.width) * .5;
            inventoryText.y = 53;


            textFieldStamp = new TextField();
            textFieldStamp.autoSize = TextFieldAutoSize.LEFT;
            textFieldStamp.antiAliasType = AntiAliasType.ADVANCED;
            textFieldStamp.sharpness = 200;
            textFieldStamp.embedFonts = true;
            textFieldStamp.defaultTextFormat = TextFieldFactory.textFormatSmall;
            textFieldStamp.background = true;
            textFieldStamp.backgroundColor = 0x000000;

            // DEBUG Code
            SpriteSheetFactory.parseSpriteSheet(spriteSheet);
            // Remove



            //TODO need to add support for equipment logic
            playerSprite = addChild(new Bitmap()) as Bitmap;
            playerSprite.x = 10;
            playerSprite.y = inventoryText.y + inventoryText.height + 5;
            updatePlayerDisplay();

            createCoinDisplay();

            statsTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, formatStatsText(), 160)) as TextField;
            statsTF.x = playerSprite.x + playerSprite.width;
            statsTF.y = playerSprite.y;

            scrollerContainer = addChild(new Sprite()) as Sprite;

            var unlockedLabel:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, "Items Unlocked ", fullSizeWidth)) as TextField;
            unlockedLabel.x = 10;
            unlockedLabel.y = playerSprite.y + playerSprite.height;

            offset = unlockedLabel.y + unlockedLabel.height + 10;

            createScrubber();
            //Generate Bitmap Data
            bitmapScroller = scrollerContainer.addChild(new BitmapScroller(null, "auto", true)) as BitmapScroller;
            bitmapScroller.width = fullSizeHeight - offset;
            bitmapScroller.height = fullSizeWidth;

            bitmapData = generateBitmapSheets();
            bitmapScroller.bitmapDataCollection = [bitmapData];

            unlockedLabel.htmlText += unlockedPercent + "%";

            createEaseScrollBehavior();

            scrollerContainer.rotation = 90;
            scrollerContainer.x = fullSizeWidth;
            scrollerContainer.y = offset;

            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function formatStatsText():String
        {
            var message:String =
                    "<span class='lightGrey'>Wins:</span>\n<span class='green'>" + activeState.totalWins + "</span>\n" +
                    "<span class='lightGrey'>Losses:</span>\n<span class='red'>" + activeState.totalLosses + "</span>\n" +
                    "<span class='lightGrey'>Turns:</span>\n" + activeState.totalTurns;
            return message;
        }

        private function updatePlayerDisplay():void
        {
            var sprites:Array = [TileTypes.getTileSprite("@")];

            if (activeState.equippedInventory[SlotsEnum.ARMOR])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.ARMOR]));

            if (activeState.equippedInventory[SlotsEnum.HELMET])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.HELMET]));

            if (activeState.equippedInventory[SlotsEnum.BOOTS])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.BOOTS]));

            if (activeState.equippedInventory[SlotsEnum.SHIELD])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.SHIELD]));

            if (activeState.equippedInventory[SlotsEnum.WEAPON])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.WEAPON]));


            playerSprite.bitmapData = BitmapUtil.upscaleBitmapData(spriteSheet.getSprite.apply(this, sprites),2);
        }

        private function createCoinDisplay():void
        {
            coinContainer = addChild(new Bitmap(new BitmapData(110, 65, true, 0))) as Bitmap;
            var bmd:BitmapData = coinContainer.bitmapData;

            var totalMoney:int = 0;


            var sprites:Array = ["C1","C2","C3"];
            var i:int;
            var bitmap:Bitmap;

            for (i = 0; i < 3; i++)
            {
                var matrix:Matrix = new Matrix();
                matrix.scale(1, 1)
                matrix.translate(40 * i, 16);
                coinContainer.bitmapData.draw(spriteSheet.getSprite(TileTypes.getTileSprite(sprites[i])), matrix);

                var total:int = activeState.getCoins()[sprites[i]];
                textFieldStamp.text = total == 0 ? "0" : total.toString();
                matrix = new Matrix();
                matrix.translate(40 * i + ((32 - textFieldStamp.width) * .5), textFieldStamp.height + 34);
                bmd.draw(textFieldStamp, matrix);

                totalMoney += total * (i + 1);
            }
            coinContainer.x = fullSizeWidth - coinContainer.width - 10;
            coinContainer.y = playerSprite.y + 5;

            textFieldStamp.textColor = 0xf1f102;
            textFieldStamp.text = "COINS: $" + totalMoney;
            bmd.draw(textFieldStamp);
        }

        private function onClick(event:MouseEvent):void
        {
            testButtonPress()
        }

        private function testButtonPress():void
        {
            var x:int = mouseX;
            var y:int = (mouseY - scrollerContainer.y) + bitmapScroller.scrollX;
            var matrix:Matrix = new Matrix();
            var rect:Rectangle;
            var stamp:BitmapData;
            for (var id:String in instancesRects)
            {
                rect = instancesRects[id];
                if (rect.contains(x, y) && (activeState.getUnlockedEquipment().indexOf(id) != -1))
                {
                    trace("Equip", id);
                    //textFieldStamp.textColor = 0xff0000;
                    textFieldStamp.text = TileTypes.getTileName(id);

                    //stamp = new BitmapData(textFieldStamp.width, textFieldStamp.height);
                    //stamp.draw(text)
                    matrix.rotate(Math.PI * 2 * (-90 / 360));
                    matrix.translate(Math.round(rect.y + rect.height), Math.round((bitmapData.height - rect.x) - ((tileSize - textFieldStamp.width) * .5)));
                    //matrix.translate(Math.round(,tileSize - bitmapData.  );
                    //bitmapData.draw(textFieldStamp, matrix, null, null, null, true);
                    //bitmapScroller.invalidate(BitmapScroller.INVALID_VISUALS);

                    switch (id.substr(0, 1))
                    {
                        case "W":
                            if (activeState.equippedInventory[SlotsEnum.WEAPON] == id)
                                delete activeState.equippedInventory[SlotsEnum.WEAPON];
                            else
                                activeState.equippedInventory[SlotsEnum.WEAPON] = id;
                            break;
                        case "S":
                            if (activeState.equippedInventory[SlotsEnum.SHIELD] == id)
                                delete activeState.equippedInventory[SlotsEnum.SHIELD];
                            else
                                activeState.equippedInventory[SlotsEnum.SHIELD] = id;
                            break;
                        case "A":
                            if (activeState.equippedInventory[SlotsEnum.ARMOR] == id)
                                delete activeState.equippedInventory[SlotsEnum.ARMOR];
                            else
                                activeState.equippedInventory[SlotsEnum.ARMOR] = id;
                            break;
                        case "B":
                            if (activeState.equippedInventory[SlotsEnum.BOOTS] == id)
                                delete activeState.equippedInventory[SlotsEnum.BOOTS];
                            else
                                activeState.equippedInventory[SlotsEnum.BOOTS] = id;
                            break;
                        case "H":
                            if (activeState.equippedInventory[SlotsEnum.HELMET] == id)
                                delete activeState.equippedInventory[SlotsEnum.HELMET];
                            else
                                activeState.equippedInventory[SlotsEnum.HELMET] = id;
                            break;
                    }

                    updatePlayerDisplay();
                    return;
                }
            }
        }

        private function generateBitmapSheets():BitmapData
        {
            var sprites:Array = SpriteFactory.equipment.slice();

            var i:int = 0;
            var total:int = sprites.length;
            var padding:int = 20;
            var inventoryWidth:int = fullSizeWidth - 20;
            var columns:int = 2;//Math.ceil(inventoryWidth / tileSize) - 1;
            var rows:int = Math.ceil(total / columns);

            // calculate left/right margin for each item
            var leftMargin:int = 0;
            var rightMargin:int = 30;//Math.round((inventoryWidth - 10 - ((tileSize + padding) * columns))/columns);
            trace("rightMargin", rightMargin / columns);
            var currentPage:BitmapData = new BitmapData(inventoryWidth, ((tileSize + padding) * rows) + 10, true, 0);
            var currentColumn:int = 0;
            var currentRow:int = 0;
            var foundColorMatrix:ColorTransform = new ColorTransform();
            var unlocked:int = 0;
            var unlockedEquipment:Array = activeState.getUnlockedEquipment();
            var newX:int;
            var newY:int;
            textFieldStamp.textColor = 0xffffff;
            for (i = 0; i < total; i++)
            {
                currentColumn = i % columns;

                var matrix:Matrix = new Matrix();

                newX = (currentColumn * (tileSize + padding + rightMargin) + leftMargin);
                newY = (currentRow * (tileSize + padding)) + 5;

                matrix.translate(newX, newY);

                instancesRects[sprites[i]] = new Rectangle(newX, newY, tileSize, tileSize);

                //TODO test if item is found
                if (unlockedEquipment.indexOf(sprites[i]) == -1)
                {
                    foundColorMatrix.alphaMultiplier = .2;
                }
                else
                {
                    foundColorMatrix.alphaMultiplier = 1;
                    unlocked ++;
                }

                //TODO this needs to be optimized
                currentPage.draw(BitmapUtil.upscaleBitmapData(spriteSheet.getSprite(TileTypes.getEquipmentPreview(sprites[i]))), matrix, foundColorMatrix);

                textFieldStamp.text = TileTypes.getTileName(sprites[i]);
                matrix.translate(Math.round((tileSize - textFieldStamp.width) * .5), tileSize);
                currentPage.draw(textFieldStamp, matrix, foundColorMatrix);

                if (currentColumn == columns - 1)
                {
                    currentRow ++;
                }

            }

            unlockedPercent = Math.round(unlocked / total * 100);

            // Rotate the bitmap for the scroller

            var rotatedBMD:BitmapData = new BitmapData(currentPage.height, currentPage.width, true, 0);
            var rotatedMatrix:Matrix = new Matrix();
            rotatedMatrix.rotate(Math.PI * 2 * (-90 / 360));
            rotatedMatrix.translate(0, rotatedBMD.height);
            rotatedBMD.draw(currentPage, rotatedMatrix);

            return rotatedBMD;


        }

        override public function onStart():void
        {
            super.onStart();

            var menuBar:MenuBar = addChild(new MenuBar(MenuBar.EXIT_ONLY_MODE, logo.width, this)) as MenuBar;
            menuBar.x = logo.x;
            menuBar.y = logo.y + logo.height - 2;
            enableLogo();
        }

        private function createScrubber():void
        {
            var sWidth:int = fullSizeHeight - offset;
            var sHeight:int = 20;
            var dWidth:int = 60;
            var corners:int = 0;

            slider = new Slider(sWidth, sHeight, dWidth, corners, 0);
            //slider.y = fullSizeHeight - slider.height - 20;

            slider.addEventListener(Event.CHANGE, onSliderValueChange)
            scrollerContainer.addChild(slider);

        }

        private function onSliderValueChange(event:Event):void
        {
            //trace("Slider Changed", slider.value);
        }

        /**
         *
         */
        private function createEaseScrollBehavior():void
        {
            easeScrollBehavior = new EaseScrollBehavior(bitmapScroller, 0);
        }

        override public function update(elapsed:Number = 0):void
        {
            var percent:Number = slider.value / 100;
            var s:Number = bitmapScroller.totalWidth;
            var t:Number = bitmapScroller.width;

            easeScrollBehavior.targetX = percent * (s - t);
            //
            easeScrollBehavior.update();
            //
            bitmapScroller.render();

            super.update(elapsed);
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
