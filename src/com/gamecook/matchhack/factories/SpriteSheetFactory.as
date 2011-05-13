/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/13/11
 * Time: 3:42 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories
{
    import com.gamecook.frogue.sprites.SpriteSheet;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    public class SpriteSheetFactory
    {
        [Embed(source="../../../../../build/assets/tc_sprite_sheet.png")]
        public static var SpriteSheetImage:Class;

        private static const TILE_SIZE:int = 64;

        public static function parseSpriteSheet(spriteSheet:SpriteSheet):void
        {
            spriteSheet.clear();

            // create sprite sheet
            var bitmap:Bitmap = new SpriteSheetImage();
            spriteSheet.bitmapData = bitmap.bitmapData;
            var i:int;
            var total:int = Math.floor(bitmap.width / TILE_SIZE);
            var spriteRect:Rectangle = new Rectangle(0, 0, TILE_SIZE, TILE_SIZE);
            for (i = 0; i < total; ++i)
            {
                spriteRect.x = i * TILE_SIZE;
                spriteSheet.registerSprite("sprite" + i, spriteRect.clone());
            }

            createLifeBar(spriteSheet);
        }

        private static function createLifeBar(spriteSheet:SpriteSheet):void
        {
            var total:int = 100;
            var i:int;

            for (i = 0; i <= total; i++)
            {
                var matrix:Matrix = new Matrix();

                var bitmapData:BitmapData = new BitmapData(TILE_SIZE, TILE_SIZE, true, 0x000000);
                var xOffset:int = bitmapData.width - 2;

                var bg:BitmapData = new BitmapData(2, bitmapData.height, false, 0xff0000);

                var lifeBarHeight:Number = Math.floor(bitmapData.height * i / total);
                if (lifeBarHeight <= 0) lifeBarHeight = 1;
                var lifeBarY:Number = bitmapData.height - lifeBarHeight;
                var bar:BitmapData = new BitmapData(2, lifeBarHeight, false, 0x00ff00);

                matrix.translate(xOffset, 0);
                bitmapData.draw(bg, matrix);

                matrix.translate(0, lifeBarY);
                bitmapData.draw(bar, matrix);

                spriteSheet.cacheSprite("life" + Math.round(i / total * 100), bitmapData);
            }
        }
    }
}
