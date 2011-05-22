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

    public class InventoryActivity extends LogoActivity
    {

        [Embed(source="../../../../../build/assets/inventory_text.png")]
        private var InventoryText:Class;

        var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
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
            inventoryText.y = 43;


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


            createCoinDisplay();

            //TODO need to add support for equipment logic
            playerSprite = addChild(new Bitmap()) as Bitmap;
            playerSprite.x = 10;
            playerSprite.y = 95;
            updatePlayerDisplay();

            statsTF = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatSmall, formatStatsText(), 160)) as TextField;
            statsTF.x = playerSprite.x + playerSprite.width + 7
            statsTF.y = playerSprite.y;

            scrollerContainer = addChild(new Sprite()) as Sprite;

            createScrubber();
            //Generate Bitmap Data
            bitmapScroller = scrollerContainer.addChild(new BitmapScroller(null, "auto", true)) as BitmapScroller;
            bitmapScroller.width = fullSizeHeight - offset;
            bitmapScroller.height = fullSizeWidth;

            bitmapData = generateBitmapSheets();
            bitmapScroller.bitmapDataCollection = [bitmapData];

            var unlockedLabel:TextField = addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLarge, "Items Unlocked "+unlockedPercent+"%", fullSizeWidth)) as TextField;
            unlockedLabel.x = 10;
            unlockedLabel.y = 165;

            createEaseScrollBehavior();

            scrollerContainer.rotation = 90;
            scrollerContainer.x = fullSizeWidth;
            scrollerContainer.y = offset;

            addEventListener(MouseEvent.CLICK, onClick)
        }

        private function formatStatsText():String
        {
            var message:String =
                    "Wins:\n999,999,999\n"+// + activeState.playerLife + "\n" +
                    "Losses:\n999,999,999\n"+// + activeState.playerLife + "\n" +
                    "Turns:\n999,999,999";// + activeState.playerLife + "\n" +
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


            playerSprite.bitmapData = spriteSheet.getSprite.apply(this, sprites);
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
                matrix.scale(.5, .5)
                matrix.translate(40 * i, 16);
                coinContainer.bitmapData.draw(spriteSheet.getSprite(TileTypes.getTileSprite(sprites[i])), matrix);

                var total:int = activeState.getCoins()[sprites[i]];
                textFieldStamp.text = total == NaN ? "0" : total.toString();
                matrix = new Matrix();
                matrix.translate(40 * i + ((32 - textFieldStamp.width) * .5), textFieldStamp.height + 34);
                bmd.draw(textFieldStamp, matrix);

                totalMoney += total * (i + 1);
            }
            coinContainer.x = fullSizeWidth - coinContainer.width - 10;
            coinContainer.y = 100;

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


            var columns:int = Math.floor(fullSizeWidth / tileSize) - 1;
            var rows:int = Math.ceil(fullSizeHeight / tileSize);
            var i:int = 0;
            var total = sprites.length;
            //TODO something is wrong here, not sure why I need to add all the extra padding to the height
            var currentPage:BitmapData = new BitmapData(fullSizeWidth, (tileSize * rows) + 1160, true, 0);
            var currentColumn:int = 0;
            var currentRow:int = 0;
            var foundColorMatrix:ColorTransform = new ColorTransform();

            var unlocked:int = 0;
            var unlockedEquipment:Array = activeState.getUnlockedEquipment();
            var newX:int;
            var newY:int;

            for (i = 0; i < total; i++)
            {
                currentColumn = i % columns;

                var matrix:Matrix = new Matrix();

                newX = (currentColumn * (tileSize + 20)) + 10;
                newY = (currentRow * (tileSize + 20)) + 5;

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

                currentPage.draw(spriteSheet.getSprite(TileTypes.getEquipmentPreview(sprites[i])), matrix, foundColorMatrix);

                textFieldStamp.text = TileTypes.getTileName(sprites[i]);
                matrix.translate(Math.round((tileSize - textFieldStamp.width) * .5), tileSize);
                currentPage.draw(textFieldStamp, matrix, foundColorMatrix);

                if (currentColumn == columns - 1)
                {
                    currentRow ++;
                }

            }

            unlockedPercent = Math.round(unlocked/total * 100);

            // Rotate the bitmap for the scroller

            /*tmpBM.rotation = -90;
             tmpBM.y = tmpBM.height;*/
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


        override public function onBack():void
        {
            nextActivity(StartActivity);
        }
    }
}
