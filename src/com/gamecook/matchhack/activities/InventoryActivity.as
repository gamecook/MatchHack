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
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.matchhack.factories.SpriteSheetFactory;
    import com.gamecook.matchhack.factories.TextFieldFactory;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class InventoryActivity extends LogoActivity
    {
        var spriteSheet:SpriteSheet = SingletonManager.getClassReference(SpriteSheet);
        private var bitmapScroller:BitmapScroller;
        private var slider:Slider;
        private var easeScrollBehavior:EaseScrollBehavior;
        private var scrollerContainer:Sprite;

        public function InventoryActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            // DEBUG Code
            SpriteSheetFactory.parseSpriteSheet(spriteSheet);
            // Remove
            var offset:int = 100;

            scrollerContainer = addChild(new Sprite()) as Sprite;

            createScrubber();
            //Generate Bitmap Data
            bitmapScroller = scrollerContainer.addChild(new BitmapScroller()) as BitmapScroller;
            bitmapScroller.width = fullSizeHeight - offset;
            bitmapScroller.height = fullSizeWidth;
            bitmapScroller.bitmapDataCollection = [generateBitmapSheets()];

            createEaseScrollBehavior();

            scrollerContainer.rotation = 90;
            scrollerContainer.x = fullSizeWidth;
            scrollerContainer.y = offset;
        }

        private function generateBitmapSheets():BitmapData
        {
            var sprites:Array = [['sprite60','Spear'],
                                ['sprite61', 'Cane'],
                                ['sprite62','Magic Wand'],
                                ['sprite63','Lead Pipe'],
                                ['sprite64','Knuckles'],
                                ['sprite65','Dagger'],
                                ['sprite66','Foil'],
                                ['sprite67','Mace'],
                                ['sprite68','Axe'],
                                ['sprite69','Croquet Mallot'],
                                ['sprite70','Whip'],
                                ['sprite71','Club'],
                                ['sprite72','Stick'],
                                ['sprite73','Shield 1'],
                                ['sprite74','Shield 2'],
                                ['sprite75','Shield 3'],
                                ['sprite76','Shield 4'],
                                ['sprite77','Shield 5'],
                               ['sprite78','Spear'],
                               ['sprite79','Spear'],
                               ['sprite80','Spear'],
                               ['sprite81','Spear'],
                               ['sprite82','Spear'],
                               ['sprite83','Spear'],
                               ['sprite84','Spear'],
                               ['sprite85','Spear'],
                               ['sprite86','Spear'],
                               ['sprite87','Spear'],
                               ['sprite89','Spear'],
                               ['sprite90','Spear'],
                               ['sprite91','Spear'],
                               ['sprite92','Spear'],
                               ['sprite93','Spear'],
                               ['sprite94','Spear']];

            var tileSize:int = 64;
            var columns:int = Math.floor(fullSizeWidth / tileSize);
            var rows:int = Math.ceil(fullSizeHeight / tileSize);
            var i:int = 0;
            var total = sprites.length;
            var currentPage:BitmapData = new BitmapData(fullSizeWidth, tileSize * rows+ 330, true, 0);
            var currentColumn:int = 0;
            var currentRow:int = 0;
            var foundColorMatrix:ColorTransform = new ColorTransform();

            var textField:TextField = new TextField();
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.embedFonts = true;
            textField.defaultTextFormat = TextFieldFactory.textFormatSmall;

            for(i=0; i< total; i++)
            {
                currentColumn = i % columns;

                var matrix:Matrix = new Matrix();

                matrix.translate(currentColumn * tileSize, (currentRow * (tileSize + 20))+5);

                //TODO test if item is found
                foundColorMatrix.alphaMultiplier = .2;
                currentPage.draw(spriteSheet.getSprite(sprites[i][0]), matrix, foundColorMatrix);

                textField.text = sprites[i][1];
                matrix.translate(Math.round((tileSize - textField.width) * .5),tileSize);
                currentPage.draw(textField, matrix);

                if(currentColumn == columns-1)
                {
                    currentRow ++;
                }

            }

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
        }

        private function createScrubber():void
        {
            var sWidth:int = fullSizeHeight - 100;
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
            trace("Slider Changed", slider.value);
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
    }
}
