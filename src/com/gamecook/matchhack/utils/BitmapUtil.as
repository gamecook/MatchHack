/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/29/11
 * Time: 9:28 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.utils
{

    import flash.display.BitmapData;
    import flash.geom.Matrix;

    public class BitmapUtil
    {
        public static function upscaleBitmapData(target:BitmapData, scale:int = 2):BitmapData
        {
            var matrix:Matrix = new Matrix();
            matrix.scale(scale,scale);

            var tmpBMD:BitmapData = new BitmapData(target.width * scale, target.height * scale, true, 0);

            tmpBMD.draw(target, matrix);

            return tmpBMD;
        }
    }
}
